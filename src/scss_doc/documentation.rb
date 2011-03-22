require 'rubygems'
require 'fileutils'
require 'sass'

module SCSSDoc
  class Documentation
    class Section
      attr_accessor :lines
      
      def initialize(lines)
        self.lines = lines
      end

      def to_s
        lines.join("\n")
      end
    end
    
    class TextSection < Section
      def to_html
        result = "<p>"
        result << lines.collect {|l|l.strip}.join("\n").gsub(/\n\n+/, '</p><p>').gsub(/\n/, ' ').strip
        result << "</p>"
        result.gsub('<p></p>', '')
      end
    end
    
    class Sections < Array
      def to_html
        collect {|section| section.to_html}
      end
    end
    
    attr_accessor :comment
    attr_accessor :sections
    
    attr_accessor :cfg
    attr_accessor :type
    attr_accessor :options
    
    def self.tags
      @tags = [:cfg, :type, :options]
    end
    
    def initialize(comment)
      @comment = comment
      @sections = Sections.new
      parse_documentation
      
      puts self.inspect
    end
    
    def to_s
      @comment
    end
    
    def parse_tags(line)
      self.class.tags.each do |tag|
        rx = /@#{tag.to_s.gsub('_', '-')}/
        if line =~ rx
          instance_variable_set(:"@#{tag}", line.gsub(rx, "").strip)
          return true
        end
      end
      return false
    end
    
    def parse_comment
      @parsed_comment ||= comment.gsub(/\*\/$/, '').split("\n").collect { |line| line.gsub(/^\s*\*/, '').gsub(/^\/\*\*/, '') }
    end
    
    def parse_documentation
      lines = parse_comment
      parse(lines)
    end
    
    def empty?
      parse_comment.join("\n").strip.empty?
    end
  
    def parse(lines)
      section_type = TextSection
      section_text = ""
      
      lines.each do |line|
        unless parse_tags(line)
          section_text << line
        end
      end
      
      sections << section_type.new(section_text.strip.gsub('  ', ' '))
    end
  end
end

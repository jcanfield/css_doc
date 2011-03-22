module SCSSDoc
  class CommentNode < Sass::Tree::CommentNode
    attr_accessor :file
    attr_accessor :class
    attr_accessor :cfg
    attr_accessor :type
    attr_accessor :options
    attr_accessor :description
    
    def parse_tags(line)
      @tags.each do |tag|
        rx = /@#{tag.to_s.gsub('_', '-')}/
        if line =~ rx
          instance_variable_set(:"@#{tag}", line.gsub(rx, "").strip)
          return true
        end
      end
      return false
    end
    
    def parse
      @tags = [:file, :class, :cfg, :type, :options, :description]
      lines = parse_comment
      parse_lines(lines)
    end
    
    def parse_comment
      @parsed_comment ||= value.gsub(/\*\/$/, '').split("\n").collect { |line| line.gsub(/^\s*\*/, '').gsub('/**', '').strip }
    end
    
    def parse_lines(lines)
      section_text = ""
      lines.each do |line|
        unless parse_tags(line)
          section_text << line
        end
      end
      instance_variable_set(:"@description", section_text.gsub('  ', ' ').strip)
    end
  end
end
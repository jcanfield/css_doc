require 'rubygems'
require 'fileutils'
require 'sass'

module SCSSDoc
  class Driver
    def run(options = {})
      @options = options
      
      @collection = SCSSDoc::DocumentCollection.new

      generate_file_documentation
      generate_index_documentation
      copy_additional_files
    end
    
    def generate_file_documentation
      log "generate_file_documentation"
      
      skip_files = @options[:skip_files] || []
      
      Dir.glob("#{@options[:input_dir]}/**/*.scss").each do |file_name|
        relative_path = file_name.gsub("#{@options[:input_dir]}/", '')
        next if skip_files.include?(relative_path)
        
        log "Generating documentation for file #{relative_path} ..."

        FileUtils.mkdir_p("#{@options[:output_dir]}/#{File.dirname(relative_path)}")
        doc = SCSSDoc::Document.new(File.read(file_name))
        doc.parse relative_path
        
        generate(:template => 'document', :file_name => doc.output_file_name, :locals => { :document => doc, :title => doc.name })

        @collection.documents << doc
      end
    end
    
    def generate_index_documentation
      log "Generating Variable Index ..."
       
      generate(:template => 'variable_index', :locals => { :collection => @collection, :title => 'Variable Index' })
      
      #log "Generating Selector Index ..."
       
      #generate(:template => 'selector_index', :locals => { :collection => @collection, :title => 'Selector Index' })

      log "Generating File Index ..."

      generate(:template => 'file_index', :locals => { :collection => @collection, :title => 'File Index' })

      # log "Generating Section Index ..."
      # 
      # generate(:template => 'section_index', :locals => { :collection => @collection, :title => 'Section Index' })
      # 
      # log "Generating Example Index ..."
      # 
      # generate(:template => 'example_index', :locals => { :collection => @collection, :title => 'Example Index' })
      # 
      # log "Generating Index Page ..."
      # 
      # generate(:template => 'index', :locals => { :project_name => @options[:project_name], :title => 'Index' })
    end
    
    def copy_additional_files
      log "Copying Additional Files ..."

      FileUtils.cp("#{@options[:template_path]}/css_doc.css", "#{@options[:output_dir]}/")
    end
    
    def log(string)
      puts string if @options[:verbose]
    end
    
  private
    def generate(params)
      file_name = params[:file_name] || params[:template]
      file_name += '.html' unless file_name =~ /\.html$/
      
      relative_root = '.'
      relative_root = (['..'] * File.dirname(file_name).split('/').size).join('/') if file_name =~ /\//

      html = SCSSDoc::Template.new(@options.merge(:relative_root => relative_root)).render(params[:template], params[:locals])
      File.open("#{@options[:output_dir]}/#{file_name}", 'w') { |file| file.puts html }
    end
  end
end

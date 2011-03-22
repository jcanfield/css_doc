module SCSSDoc
  class Document < Sass::Tree::RootNode
    # attr_accessor :documentation
    # attr_accessor :sections
    attr_accessor :name
    attr_accessor :description
    attr_accessor :class
    
    attr_accessor :comments
    attr_accessor :variables
    
    def parse name
      self.name = name
      
      self.comments = []
      self.variables = []
      
      parser = Sass::SCSS::Parser.new template
      root_node = parser.parse
      
      @children = root_node.children
      
      parse_children
    end
    
    def parse_children
      array = []
      comment = nil
      
      @children.each {|child|
        if child.class == Sass::Tree::CommentNode
          node = SCSSDoc::CommentNode.new(child.value, child.silent)
          node.parse
          
          comment = node
          
          if child.value.match /@file/
            self.description = node.description
            self.class = node.class
          else
            self.comments << node
            array << node
          end
        else
          if comment
            tags = comment.instance_variable_get "@tags"
            if tags
              tags.each {|t|
                if comment.instance_variable_defined? "@#{t}"
                  var = comment.instance_variable_get "@#{t}"
                  child.instance_variable_set "@#{t}", var
                end
              }
            end
            
            comment = nil
          end
          
          if child.class == Sass::Tree::VariableNode
            self.variables << child
          else
            array << child
          end
        end
      }
      
      @children = array
    end
    
    def output_file_name
      name.gsub('.scss', '_scss.html')
    end
    
    # def named_sections
    #   sections.reject {|section| section.name.nil?}
    # end
  end
end

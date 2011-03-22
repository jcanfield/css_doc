module SCSSDoc
  class DocumentCollection
    attr_accessor :documents
    
    def initialize
      @documents = []
    end
    
    def rule_nodes
      documents.collect { |document| document.children }.flatten
    end
    
    def variables
      documents.collect { |document| document.variables }.flatten
    end
    
    def sections
      documents.collect { |document| document.sections }.flatten
    end
    
    def named_sections
      sections.reject { |section| section.name.nil? }
    end
    
    def selector_hash
      selectors.inject({}) { |hash, selector| (hash[selector.to_css] ||= []) << selector; hash }
    end
    
    def variable_hash
      array = []
      
      variables.each{|v|
        array << {
          :name => v.name
        }
      }
      
      array
    end
    
    def section_hash
      named_sections.inject({}) { |hash, section| (hash[section.name] ||= []) << section; hash }
    end
  end
end

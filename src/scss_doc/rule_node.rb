module SCSSDoc
  class RuleNode < Sass::Tree::RuleNode
    attr_accessor :documentation
    
    def selector_css
      @selector_css ||= selectors.collect { |selector| selector.to_css }.join(", ")
    end
    
    def declaration_css
      @declaration_css ||= declarations.collect { |declaration| declaration.to_css }.join(' ')
    end
  end
end

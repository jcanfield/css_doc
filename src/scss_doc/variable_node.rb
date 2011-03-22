module SCSSDoc
  class VariableNode < Sass::Tree::VariableNode
    attr_accessor :name
    attr_accessor :expr
    attr_accessor :tags
    
    attr_accessor :cfg
    attr_accessor :type
    attr_accessor :options
    attr_accessor :description
    
    def initialize(name, expr, guarded)
      @tags = [:cfg, :type, :options, :description]
      
      @name = name
      @expr = expr
      @guarded = guarded
      super()
    end
end
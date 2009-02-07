require 'forwardable'

module Heist
  class Runtime
    
    %w[ expression
        list
        identifier
        function
        macro/macro
        continuation
        stack
        frame
        scope
        binding
    ].each do |file|
      require RUNTIME_PATH + file
    end
    
    extend Forwardable
    def_delegators(:@scope, :[], :eval, :run, :define, :metadef, :call)
    
    attr_reader :order
    attr_accessor :stack
    
    def initialize(options = {})
      @scope = Scope.new(self)
      @stack = Stack.new
      
      @order = options[:order] || EAGER
      
      instance_eval(File.read("#{ BUILTIN_PATH }common.rb"))
      run("#{ BUILTIN_PATH }common.scm")
      
      @start_time = Time.now.to_f
    end
    
    def elapsed_time
      (Time.now.to_f - @start_time) * 1000000
    end
    
    def lazy?
      @order == NORMAL_ORDER
    end
    
  end
end


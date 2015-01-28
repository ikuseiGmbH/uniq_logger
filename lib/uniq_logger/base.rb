module UniqLogger
  class Base
    def initialize(opts={}, &block)
      Configuration.configure_with_path
    end

    def config
      Configuration.config
    end
    
  end
end

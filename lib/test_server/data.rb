module TestServer
  class Data
    private

    attr_reader :config

    public

    def initialize(config = TestServer.config)
      @config = config
    end

    def instance_binding
      binding
    end

    def lookup(variable)
      config.public_send variable.to_sym
    rescue NoMethodError
      fail "Variable \"#{variable}\" not found."
    end
  end
end

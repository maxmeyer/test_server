# encoding: utf-8
module TestServer
  class ProcessEnvironment
    private

    attr_reader :environment

    public

    def initialize(environment = ENV)
      @environment = environment
      
    end

    def fetch(key, default_value = nil)
      environment.to_hash.symbolize_keys.fetch(key.to_sym, default_value).to_s
    end

    def write(key, value)
      environment[key.to_s] = value
    end
  end
end

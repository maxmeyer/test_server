# encoding: utf-8
module TestServer
  class ProcessEnvironment
    private

    attr_reader :environment

    public

    def initialize(environment = ENV.to_hash)
      @environment = environment.symbolize_keys
    end

    def fetch(key, default_value = nil)
      environment.fetch(key.to_sym, default_value).to_s
    end
  end
end

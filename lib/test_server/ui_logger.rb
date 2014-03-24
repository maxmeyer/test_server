module TestServer
  class UiLogger

    private

    attr_reader :logger

    public

    def initialize
      @logger = ::Logger.new($stderr)
    end

    def level=(l)
      logger.level = case l.to_s.to_sym
                      when :unknown
                        ::Logger::UNKNOWN
                      when :fatal
                        ::Logger::FATAL
                      when :error
                        ::Logger::ERROR
                      when :warn
                        ::Logger::WARN
                      when :info
                        ::Logger::INFO
                      when :debug
                        ::Logger::DEBUG
                      else
                        ::Logger::ERROR
                      end
    end

    def method_missing(method, *args, &block)
      logger.public_send method, *args
    end
  end
end

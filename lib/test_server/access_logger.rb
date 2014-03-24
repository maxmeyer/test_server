module TestServer
  class AccessLogger
    def initialize(path)
      @logger = ::Logger.new(::File.expand_path(path))
    rescue Errno::ENOENT
      raise Exceptions::AccessLogPathInvalid, JSON.dump(file: path, directory: ::File.dirname(path) )
    end

    def write(*args, &block)
      @logger.<<(*args, &block)
    end
  end
end

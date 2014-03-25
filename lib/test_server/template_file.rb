# encoding: utf-8
module TestServer
  class TemplateFile

    attr_reader :path

    def initialize(path)
      @path = ::File.expand_path(path)
    end

    def name
      ::File.basename(path, '.*').to_sym
    end

    def read
      ::File.read(path)
    end
  end
end

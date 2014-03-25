# encoding: utf-8
module TestServer
  class TemplateRepository
    private

    attr_reader :root_directory, :creator

    public

    def initialize(root_directory = ::File.expand_path('../../../files', __FILE__), creator = TemplateFile)
      @root_directory = ::File.expand_path(root_directory)
      @creator        = creator
    end

    def find(name)
      path = ::File.join(root_directory, "#{name.to_s}.erb")
      fail Exceptions::ErbTemplateIsUnknown, "Template \"#{name}\" could not be found!" unless ::File.exist? path

      creator.new(path)
    end
  end
end

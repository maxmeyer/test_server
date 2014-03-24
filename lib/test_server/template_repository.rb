# encoding: utf-8
module TestServer
  class FileRepository
    private

    attr_reader :root_directory, :creator

    public

    def initialize(root_directory = ::File.expand_path('../../../files', __FILE__), creator = LocalFile)
      @root_directory = ::File.expand_path(root_directory)
      @creator        = creator
    end

    def find(name)
      path = ::File.join(root_directory, "#{name.to_s}.erb")
      fail Exceptions::LocalFileIsUnknown, JSON.dump(file: name) unless ::File.exist? path

      creator.new(path)
    end
  end
end

# encoding:utf-8
module TestServer
  class Server

    private

    attr_reader :command

    public

    def initialize(command = ServerCommands::Rackup.new)
      @command = command
    end

    def start
      exec command.to_s
    end
  end
end

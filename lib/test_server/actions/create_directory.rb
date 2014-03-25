# encoding: utf-8
module TestServer
  module Actions
    class CreateDirectory
      private

      attr_reader :fs_engine, :path, :options

      public

      def initialize(path, options = {}, fs_engine = FileUtils)
        @path      =::File.expand_path(path)
        @options   = options
        @fs_engine = fs_engine
      end

      def run
        if need_to_run? || options[:force] == true
          TestServer.ui_logger.warn "Creating directory \"#{path}\"."
          fs_engine.mkdir_p(path)
        else
          TestServer.ui_logger.warn "Directory \"#{path}\" already exists. Do not create it again!."
        end
      end

      private

      def need_to_run?
        !::File.exists?(path)
      end
    end
  end
end

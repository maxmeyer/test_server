# encoding: utf-8
module TestServer
  module Actions
    class CreateFile
      private

      attr_reader :name, :destination, :data, :options, :engine, :repository

      public

      def initialize(name, destination, data, options = {}, engine = ErbGenerator, repository = TemplateRepository.new)
        @name        = name
        @destination =::File.expand_path(destination)
        @data        = data
        @options     = options
        @engine      = engine
        @repository  = repository
      end

      def run
        if need_to_run? || options[:force] == true
          TestServer.ui_logger.warn "Creating file \"#{destination}\"."

          create_directories if options[:create_directories] == true

          file = template(name, ::File.new(destination, 'w'), data)
          FileUtils.chmod('+x', file) if options[:executable] == true
        else
          TestServer.ui_logger.warn "File \"#{destination}\" already exists. Do not create it again!."
        end
      end

      private

      def create_directories
        FileUtils.mkdir_p(::File.dirname(destination))
      end

      def template(local_name, local_destination, local_data)
        template = repository.find(local_name)

        generator = engine.new(local_data)
        generator.compile(template, local_destination)

        local_destination
      rescue Errno::ENOENT
        fail Exceptions::ErbTemplateIsUnknown, JSON.dump(message: "Unknown erb template \"#{template_path}\".")
      end

      def need_to_run?
        !::File.exists?(destination)
      end
    end
  end
end

# encoding: utf-8
module TestServer
  module Actions
    class CreateOutput
      private

      attr_reader :name, :output, :engine, :repository, :data

      public

      def initialize(name, output, data, engine = ErbGenerator, repository = TemplateRepository.new)
        @name        = name
        @output      = output
        @data        = data
        @engine      = engine
        @repository  = repository
      end

      def run
        TestServer.ui_logger.info "Creating example configuration:"
        template(name, output, data)
      end

      private

      def template(local_name, local_destination, local_data)
        template = repository.find(local_name)

        generator = engine.new(local_data)
        generator.compile(template, local_destination)
      rescue Errno::ENOENT
        fail Exceptions::ErbTemplateIsUnknown, JSON.dump(message: "Unknown erb template \"#{template_path}\".")
      end
    end
  end
end

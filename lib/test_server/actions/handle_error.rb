# encoding: utf-8
module TestServer
  module Actions
    class HandleError

      private

      attr_reader :exception, :original_message, :handler_klass

      public

      def initialize(exception, handler_klass = ErrorHandler)
        @exception        = exception.class
        @original_message = exception.message
        @handler_klass    = handler_klass
      end

      def run
        handler = handler_klass.find exception
        handler.original_message = original_message

        handler.execute(parsed_message)
      end

      private

      def parsed_message
        result = JSON.parse(original_message)
        return {} unless result.kind_of? Hash

        result
      rescue JSON::ParserError
        {}
      end
    end
  end
end

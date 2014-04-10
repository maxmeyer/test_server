# encoding: utf-8
module TestServer
  module App
    class ApplicationController < ActionController::Base
      # Prevent CSRF attacks by raising an exception.
      # For APIs, you may want to use :null_session instead.
      protect_from_forgery with: :exception
    end

      error do
        handler = ErrorHandler.find(StandardError)

        @error_summary = handler.summary(:html)
        @error_details = handler.details(:html)

        halt 500, haml(:error, layout: :application)
      end

      set :raise_sinatra_param_exceptions, true

      error Sinatra::Param::InvalidParameterError do
        handler = ErrorHandler.find(Sinatra::Param::InvalidParameterError)
        handler.use(JSON.dump(parameter: env['sinatra.error'].param))

        @error_summary = handler.summary(:html)
        @error_details = handler.details(:html)

        halt 401, haml(:error, layout: :application)
      end

      configure :profile do
        require 'ruby-prof'
        use Rack::RubyProf, files: '/tmp/profiles'

        use Rack::CommonLogger, TestServer::AccessLogger.new(TestServer.config.access_log)
        set :raise_errors, false
      end

      configure :production do
        use Rack::CommonLogger, TestServer::AccessLogger.new(TestServer.config.access_log)
        set :raise_errors, false
      end

      configure :development do
        set :raise_errors, true

        before do
          TestServer.ui_logger.debug "Parameters: " + params.to_s
        end
      end

      configure :test do
        use Rack::CommonLogger, TestServer::NullAccessLogger.new
        set :raise_errors, false
      end

      helpers do
        include Sprockets::Helpers
        include TestServer::WebHelper
      end
    end
  end
end

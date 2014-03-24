# encoding: utf-8
module TestServer
  module App
    class ApplicationController < Sinatra::Base
      set :root, ::File.expand_path('../../', __FILE__)
      set :haml, :format => :html5

      enable :protection
      enable :session

      use Rack::Deflater
      use Rack::Locale
      use Rack::NestedParams
      use Rack::PostBodyContentTypeParser

      not_found do
        handler = ErrorHandler.find(Exceptions::PacFileUnknown)
        handler.use(JSON.dump(name: env['PATH_INFO']))

        @error_summary = handler.summary(:html)
        @error_details = handler.details(:html)

        halt 404, haml(:error, layout: :application)
      end
      
      error do
        handler = ErrorHandler.find(StandardError)

        @error_summary = handler.summary(:html)
        @error_details = handler.details(:html)

        halt 500, haml(:error, layout: :application)
      end

      error Exceptions::PacResultInvalid do
        handler = ErrorHandler.find(Exceptions::PacResultInvalid)
        handler.use(env['sinatra.error'].message)

        @error_summary = handler.summary(:html)
        @error_details = handler.details(:html)

        halt 500, haml(:error, layout: :application)
      end

      error Exceptions::PacFileInvalid do
        handler = ErrorHandler.find(Exceptions::PacFileInvalid)
        handler.use(JSON.dump(name: env['sinatra.error'].message))

        @error_summary = handler.summary(:html)
        @error_details = handler.details(:html)

        halt 401, haml(:error, layout: :application)
      end

      error Exceptions::GivenUrlInvalid do
        handler = ErrorHandler.find(Exceptions::GivenUrlInvalid)
        handler.use(env['sinatra.error'].message)

        @error_summary = handler.summary(:html)
        @error_details = handler.details(:html)

        halt 401, haml(:error, layout: :application)
      end

      error Exceptions::GivenTimeInvalid do
        handler = ErrorHandler.find(Exceptions::GivenTimeInvalid)
        handler.use(env['sinatra.error'].message)

        @error_summary = handler.summary(:html)
        @error_details = handler.details(:html)

        halt 401, haml(:error, layout: :application)
      end

      error Exceptions::GivenClientIpInvalid do
        handler = ErrorHandler.find(Exceptions::GivenClientIpInvalid)
        handler.use(env['sinatra.error'].message)

        @error_summary = handler.summary(:html)
        @error_details = handler.details(:html)

        halt 401, haml(:error, layout: :application)
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
        set :local_storage, TestServer::LocalStorage.new
      end

      configure :production do
        use Rack::CommonLogger, TestServer::AccessLogger.new(TestServer.config.access_log)
        set :raise_errors, false
        set :local_storage, TestServer::LocalStorage.new
        set :translation_table, TestServer::TranslationTable.new
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
      
      configure do
        mime_type :proxy_pac_file, 'application/x-ns-proxy-autoconfig'
      end

      helpers do
        include Sprockets::Helpers

        def h(text)
          Rack::Utils.escape_html(text)
        end

        def t(*args)
          I18n.t(*args)
        end
      end
    end
  end
end

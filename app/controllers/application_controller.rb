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

      helpers Sinatra::Param
      
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

        def h(text)
          Rack::Utils.escape_html(text)
        end

        def t(*args)
          I18n.t(*args)
        end

        def generate_string(count, string = "Plain Data\n")
          string * count
        end

        def generate_eicar
          [ 'X', '5', 'O', '!', 'P', '%', '@', 'A', 'P', '[', '4', "\\", 'P',
            'Z', 'X', '5', '4', '(', 'P', '^', ')', '7', 'C', 'C', ')', '7',
            '}', '$', 'E', 'I', 'C', 'A', 'R', '-', 'S', 'T', 'A', 'N', 'D',
            'A', 'R', 'D', '-', 'A', 'N', 'T', 'I', 'V', 'I', 'R', 'U', 'S',
            '-', 'T', 'E', 'S', 'T', '-', 'F', 'I', 'L', 'E', '!', '$', 'H',
            '+', 'H', '*' ]
        end

        def configure_caching(params)
          options = []

          if params.key? 'expires'
            options << :must_revalidate
            options << :no_cache
            options << { max_age: params[:expires] }
          else
            options << :must_revalidate              if params.key? 'must_revalidate'
            options << :no_cache                     if params.key? 'no_cache'
            options << { max_age: params[:max_age] } if params.key? 'max_age'
          end

          cache_control(*options)
        end

      end
    end
  end
end

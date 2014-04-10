## encoding: utf-8
#module TestServer
#  module App
#    class AssetsController < Sinatra::Base
#      set :root, ::File.expand_path('../../', __FILE__)
#      set :assets, Sprockets::Environment.new(root)
#      set :precompile, [ /\w+\.(?!js|css).+/, /application.(css|js)$/ ]
#      set :assets_prefix, '/assets'
#      set :digest_assets, false
#      set(:assets_path) { ::File.join public_folder, assets_prefix }
#
#      enable :protection
#      enable :session
#
#      configure :profile do
#        require 'ruby-prof'
#        use Rack::RubyProf, files: '/tmp/profiles'
#
#        use Rack::CommonLogger, TestServer::AccessLogger.new(TestServer.config.access_log)
#        set :raise_errors, false
#      end
#
#      configure :production do
#        use Rack::CommonLogger, TestServer::AccessLogger.new(TestServer.config.access_log)
#        set :raise_errors, false
#        set :digest_assets, true
#
#        assets.js_compressor  = :uglify
#        assets.css_compressor = :scss
#      end
#
#      configure :development do
#        set :raise_errors, true
#      end
#
#      configure :test do
#        use Rack::CommonLogger, TestServer::NullAccessLogger.new
#        set :raise_errors, true
#      end
#
#      configure do
#
#        # Setup Sprockets
#        %w{javascripts stylesheets images}.each do |type|
#          assets.append_path "assets/#{type}"
#        end
#        assets.append_path ::File.expand_path("../../../vendor/assets/components", __FILE__)
#        assets.append_path ::File.expand_path("../../../vendor/assets/components/*/scss", __FILE__)
#
#        assets.cache = Sprockets::Cache::FileStore.new(TestServer.config.sass_cache)
#
#        # Configure Sprockets::Helpers (if necessary)
#        Sprockets::Helpers.configure do |config|
#          config.environment    = assets
#          config.prefix         = assets_prefix
#          config.digest         = digest_assets
#          config.public_path    = public_folder
#        end
#
#        Sprockets::Sass.add_sass_functions = false
#      end
#
#    end
#  end
#end

# encoding: utf-8
require 'spec_helper'

describe 'Dashboard', :js do
  before :each do
    config = Class.new do
      include FeduxOrg::Stdlib::Filesystem

      def root_directory
        ::File.expand_path('../../../', __FILE__)
      end

      def log_level
       :unknown
      end

      def access_log 
        File.join(working_directory, 'access.log')
      end

      def reload_config_signal
        'USR1'
      end
    end.new

    TestServer.config = config
    Capybara.app = Rack::Builder.new do
      map '/' do
        run TestServer::App::JavascriptController
      end

      map '/assets' do
        run TestServer::App::AssetsController.assets
      end
    end
  end

  context 'Overview test functions' do
    it 'lists links to all other test functions' do
      visit '/'
      expect(page).to have_selector 'tr a'
    end
  end
end

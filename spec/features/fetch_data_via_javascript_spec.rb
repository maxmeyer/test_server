# encoding: utf-8
require 'spec_helper'

describe 'Fetch data via javascript', :js do
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

  context '/xhr/string/' do
    it 'submits requests to url' do
      url = 'http://127.0.0.1:4567/rspec/test'
      visit '/xhr/string/'

      within '#form' do
        fill_in 'url', :with => url
      end


      click_button('submit')

      first '.ts-result-row'

      expect(page).to have_content('ok')
    end

  end
end

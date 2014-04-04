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

  context '/xhr/url/' do
    it 'submits requests to url' do
      url = '/v1/test/javascript/xhr/url'
      visit '/xhr/url/'

      within '#form' do
        fill_in 'url', :with => url
        fill_in 'count', :with => 1
      end


      click_button('submit')

      first '.ts-result-row'

      expect(page).to have_content(url)
    end

  end
end

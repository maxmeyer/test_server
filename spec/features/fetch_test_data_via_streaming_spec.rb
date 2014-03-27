# encoding: utf-8
require 'spec_helper'

describe 'Fetch Test Data via Streaming' do

  before :each do
    config = Class.new do
      include FeduxOrg::Stdlib::Filesystem

      def root_directory
        ::File.expand_path('../../../', __FILE__)
      end
    end.new

    TestServer.config = config
    Capybara.app    = TestServer::App::StreamingController.new
  end

  it 'downloads stream' do
    visit('/2')
    expect(page).to have_content('data')
  end

end

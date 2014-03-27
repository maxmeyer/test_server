# encoding: utf-8
require 'spec_helper'

describe 'Fetch plain data' do
  before :each do
    config = Class.new do
      include FeduxOrg::Stdlib::Filesystem

      def root_directory
        ::File.expand_path('../../../', __FILE__)
      end
    end.new

    TestServer.config = config
    Capybara.app    = TestServer::App::PlainController.new
  end

  it 'downloads the data' do
    visit('/')
    expect(page).to have_content('Plain Data')
  end

  it 'downloads the data with multiplier' do
    visit('/10')
    expect(page.source.split(/\n/).size).to be 10
    binding.pry
  end
end

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
    Capybara.app = TestServer::App::StreamingController.new
  end

  it 'downloads stream' do
    visit('/default?count=2')

    expect(page.status_code).to be 200
    expect(page).to have_content('data')
  end

  it 'supports base64 encoding' do
    visit('/default?count=2&base64')

    expect(page.status_code).to be 200
    expect(Base64.decode64(page.source.split(/\n/).last)).to include 'data'
  end

  it 'supports gzip encoding' do
    visit('/default?count=2&gzip')

    expect(page.status_code).to be 200
    expect(Base64.decode64(page.source.split(/\n/).last)).to include "\xC6\xC2\bODLT\x91\xCC \xC32\xC7tG \x85q\xDD\x11\xC8".force_encoding('ASCII-8bit')
  end

  it 'serves eicar test string to check if virus scanners find that string' do
    eicar = [ 'X', '5', 'O', '!', 'P', '%', '@', 'A', 'P', '[', '4', "\\", 'P',
              'Z', 'X', '5', '4', '(', 'P', '^', ')', '7', 'C', 'C', ')', '7',
              '}', '$', 'E', 'I', 'C', 'A', 'R', '-', 'S', 'T', 'A', 'N', 'D',
              'A', 'R', 'D', '-', 'A', 'N', 'T', 'I', 'V', 'I', 'R', 'U', 'S',
              '-', 'T', 'E', 'S', 'T', '-', 'F', 'I', 'L', 'E', '!', '$', 'H',
              '+', 'H', '*' ]

    visit('/eicar/')

    expect(page.status_code).to be 200
    expect(page).to have_content(eicar.join)
  end
end

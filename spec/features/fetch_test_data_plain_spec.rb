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
    Capybara.app    = TestServer::App::StringController.new
  end

  it 'downloads the data' do
    visit('/default/')

    expect(page.status_code).to eq 200
    expect(page).to have_content('Plain Data')
  end

  it 'downloads the data with multiplier' do
    visit('/default/10')

    expect(page.status_code).to eq 200
    expect(page.source.split(/\n/).size).to eq 10
  end

  it 'prevents caching' do
    visit('/default?no_cache')

    expect(page.status_code).to eq 200
    expect(page.response_headers).to be_key('Cache-Control')
    expect(page.response_headers['Cache-Control']).to include('no-cache')
  end

  it 'requires re-validation' do
    visit('/default?must_revalidate')

    expect(page.status_code).to eq 200
    expect(page.response_headers).to be_key('Cache-Control')
    expect(page.response_headers['Cache-Control']).to include('must-revalidate')
  end

  it 'sets max age' do
    visit('/default?max_age=500')

    expect(page.status_code).to eq 200
    expect(page.response_headers).to be_key('Cache-Control')
    expect(page.response_headers['Cache-Control']).to include('max-age=500')
  end

  it 'sets everything' do
    visit('/default?expires=500')

    expect(page.status_code).to eq 200
    expect(page.response_headers).to be_key('Cache-Control')
    expect(page.response_headers['Cache-Control']).to include('no-cache')
    expect(page.response_headers['Cache-Control']).to include('must-revalidate')
    expect(page.response_headers['Cache-Control']).to include('max-age=500')
  end

  it 'serves eicar test string to check if virus scanners find that string' do
    eicar = [ 'X', '5', 'O', '!', 'P', '%', '@', 'A', 'P', '[', '4', "\\", 'P',
              'Z', 'X', '5', '4', '(', 'P', '^', ')', '7', 'C', 'C', ')', '7',
              '}', '$', 'E', 'I', 'C', 'A', 'R', '-', 'S', 'T', 'A', 'N', 'D',
              'A', 'R', 'D', '-', 'A', 'N', 'T', 'I', 'V', 'I', 'R', 'U', 'S',
              '-', 'T', 'E', 'S', 'T', '-', 'F', 'I', 'L', 'E', '!', '$', 'H',
              '+', 'H', '*' ]

    visit('/eicar/')
    expect(page.status_code).to eq 200
    expect(page).to have_content(eicar.join)
  end

  it 'supports long running requests' do
    timeout(3) do
      visit('/sleep/2')
    end

    expect(page.status_code).to eq 200
    expect(page).to have_content('Plain Data')
  end

  it 'supports random string' do
    visit('/random/2')

    expect(page.status_code).to eq 200
    expect(page.source.size).to eq 2
  end

  it 'supports base64 encoding' do
    visit('/default?base64')

    expect(page.status_code).to eq 200
    expect(Base64.decode64(page.source)).to include 'Plain Data'
  end

  it 'supports base64 stric encoding' do
    visit('/default?base64_strict')

    expect(page.status_code).to eq 200
    expect(Base64.strict_decode64(page.source)).to include 'Plain Data'
  end

end

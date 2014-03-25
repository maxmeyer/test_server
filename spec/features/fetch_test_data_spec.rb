# encoding: utf-8
describe 'Fetch Test Data' do

  before :each do
    config = Class.new do
      include FeduxOrg::Stdlib::Filesystem

      def root_directory
        ::File.expand_path('../../../', __FILE__)
      end
    end.new

    TestServer.config = config
    Capybara.app    = TestServer::App::TestController.new
  end

  it 'finds an existing proxy pac' do
    visit('/stream/2')
    expect(page).to have_content("data")
  end

end

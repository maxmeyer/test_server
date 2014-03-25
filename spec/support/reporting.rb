require 'active_support/core_ext/kernel/reporting'

RSpec.configure do |c|
  c.before(:each) do
    TestServer.ui_logger.level = :unknown
  end
end


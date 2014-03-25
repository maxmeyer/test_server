module TestServer
  module Exceptions
    # user error
    class UserError < StandardError; end

    # internal error
    class InternalError < StandardError; end

    # raised if config file does not exist
    class ConfigFileNotReadable < UserError; end

    # file in repository not found
    class LocalFileIsUnknown < UserError; end

    # invalid path to access log
    class AccessLogPathInvalid < UserError; end

    # reload of configuration failed
    class ReloadOfConfigurationFailed < InternalError; end

    # raised if pid file does not exist
    class PidFileDoesNotExist < UserError; end
  end
end

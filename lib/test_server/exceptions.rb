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

    # raise if there are template syntax errrors
    class ErbTemplateHasSyntaxErrors < InternalError; end

    # raised if Template does not exist
    class ErbTemplateIsUnknown < InternalError; end

    # raised if listen statement is invalid
    class ServerListenStatementInvalid < UserError; end

    # raised if request is invalid
    class GivenUrlInvalid < UserError; end

    # raised if variable cannot be looked up
    class VariableUnknown < InternalError; end
  end
end

# encoding: utf-8
module TestServer
  module ErrorMessages
    ErrorHandler.create(
      exception: StandardError,
      summary: 'errors.default.summary',
      details: 'errors.default.details',
      exit_code: 99,
    )

    ErrorHandler.create(
      exception: Exceptions::InternalError,
      details: 'errors.internal_error.details',
      summary: 'errors.internal_error.summary',
      exit_code: 1,
    )
    
    ErrorHandler.create(
      exception: Exceptions::ConfigFileNotReadable,
      details: 'errors.unreadable_config_file.details',
      summary: 'errors.unreadable_config_file.summary',
      exit_code: 2,
    )

    ErrorHandler.create(
      exception: Exceptions::UserError,
      details: 'errors.user_error.details',
      summary: 'errors.user_error.summary',
      exit_code: 3,
    )

    ErrorHandler.create(
      exception: Sinatra::Param::InvalidParameterError,
      details: 'errors.invalid_parameter.details',
      summary: 'errors.invalid_parameter.summary',
      exit_code: 4,
    )

    ErrorHandler.create(
      exception: Exceptions::PidFileDoesNotExist,
      details: 'errors.invalid_proxy_pac.details',
      summary: 'errors.invalid_proxy_pac.summary',
      exit_code: 5,
    )

    ErrorHandler.create(
      exception: Exceptions::GivenUrlInvalid,
      details: 'errors.invalid_url.details',
      summary: 'errors.invalid_url.summary',
      exit_code: 6,
    )
    
    ErrorHandler.create(
      exception: Exceptions::ServerListenStatementInvalid,
      details: 'errors.invalid_listen_statement.details',
      summary: 'errors.invalid_listen_statement.summary',
      exit_code: 8,
    )

    ErrorHandler.create(
      exception: Exceptions::AccessLogPathInvalid,
      details: 'errors.invalid_access_log_path.details',
      summary: 'errors.invalid_access_log_path.summary',
      exit_code: 9,
    )
  end
end

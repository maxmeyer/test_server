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
  end
end

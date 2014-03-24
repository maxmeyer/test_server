# encoding: utf-8
require 'spec_helper'

describe ErrorHandler do
  let(:exception) { StandardError.new }

  context '.create' do
    it 'requires an exception class, a message and a exit code' do
      expect {
        ErrorHandler.create(
          exception: StandardError,
          details: 'errors.default.details',
          summary: 'errors.default.summary',
          exit_code: 1,
        )
      }.not_to raise_error
    end
  end

  context '.find' do
    it 'finds a suitable error handler' do
      ErrorHandler.create(
        exception: StandardError,
        details: 'errors.default.details',
        summary: 'errors.default.summary',
        exit_code: 1,
      )

      expect(ErrorHandler.find(exception)).not_to be_nil
    end

    it 'returns a default exception if the requested one cannote be found' do
      expect(ErrorHandler.find(RuntimeError.new).exception).to be(StandardError)
    end
  end

  context '#exception' do
    it 'returns the exception' do
      handler = ErrorHandler.create(
        exception: StandardError,
        details: 'errors.default.details',
        summary: 'errors.default.summary',
        exit_code: 1,
      )

      expect(handler.exception).to eq(StandardError)
    end
  end

  context '#execute' do
    it 'executes the error handler' do
      handler = ErrorHandler.new(
        exception: StandardError, 
        details: 'errors.default.details',
        summary: 'errors.default.summary',
        exit_code: 1,
      )
      handler.original_message = 'blub'

      TestServer.ui_logger.level = :debug

      result = capture(:stderr) do
        begin
          handler.execute
        rescue SystemExit => e
          expect(e.status).to eq(1)
        end
      end

      expect(result).to include('unexpected')
      expect(result).to include('blub')
    end

    it 'renders template + data' do
      handler = ErrorHandler.new(
        exception: StandardError, 
        details: 'errors.internal_error.details',
        summary: 'errors.internal_error.summary',
        exit_code: 1,
      )

      TestServer.ui_logger.level = :debug

      handler.use(message: 'help')

      result = capture(:stderr) do
        begin
          handler.execute
        rescue SystemExit
        end
      end

      expect(result).to include('help')
    end

    it 'ignores data which is not needed' do
      handler = ErrorHandler.new(
        exception: StandardError, 
        details: 'errors.default.details',
        summary: 'errors.default.summary',
        exit_code: 1,
      )
      handler.original_message = 'blub'

      TestServer.ui_logger.level = :debug
      handler.use(name: 'asdf')

      result = capture(:stderr) do
        begin
          handler.execute
        rescue SystemExit => e
          expect(e.status).to eq(1)
        end
      end

      expect(result).to include('unexpected')
      expect(result).to include('blub')
    end
  end

  context '#use' do
    it 'uses data in translation' do
      handler = ErrorHandler.new(
        exception: StandardError, 
        details: 'errors.internal_error.details',
        summary: 'errors.internal_error.summary',
        exit_code: 1,
      )

      handler.use(message: 'help')
      expect(handler.details).to include('help')
    end
  end

  context '#to_json' do
    it 'returns a json self' do
      handler = ErrorHandler.new(
        exception: StandardError, 
        details: 'errors.internal_error.details',
        summary: 'errors.internal_error.summary',
        exit_code: 1,
      )

      handler.use(message: 'help')

      expect(handler.to_json).to eq(
        JSON.dump(
          error_summary: 'Internal error...',
          error_details: 'Sorry, but I cannot fullfill your request. An internal error occured: "help". Please notify the author of the software about the problem.',
          result: "failure",
        )
      )
    end
  end
end

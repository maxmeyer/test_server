# encoding: utf-8
module TestServer
  class ErrorsController < ApplicationController
    def show
      handler = ErrorHandler.find(env['action_dispatch.exception'])

      @error_summary = handler.summary(:html)
      @error_details = handler.details(:html)

      respond_to do |format|
        format.html { render status: handler.status_code }
        format.json { render json: handler.to_hash, status: handler.status_code }
      end
    end

    private

    def error_params
      params.permit(:exception)
    end
  end
end

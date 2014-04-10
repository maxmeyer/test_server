# encoding: utf-8
module TestServer
  module App
    class GeneratorController < ApplicationController
      before do
        params.merge! default_params
      end

      def show
        @count   = url_params[:count]
        @url     = url_params[:url]
        @timeout = url_params[:timeout]
        @repeat  = %w{ on yes true t }.include?(url_params[:repeat])
      end

      private

      def default_params
        {
          count: 10,
          timeout: 1_000,
          repeat: 'false',
        }
      end

      def url_params
        params.permit(:count, :timeout, :url, :repeat)
      end
    end
  end
end

# encoding: utf-8
module TestServer
  class StringController < ApplicationController

    before do
      params.merge! default_params
    end

    def index
      redirect_to action: 'string'
    end

    def plain
      render text: encode(string_params) { generate_string(string_params[:count]) }
    end

    def eicar
      render text: encode(string_params) { generate_eicar.join }
    end

    def sleep
      sleep string_params[:count].to_i

      render text: encode(string_params) { generate_string(1) }
    end

    def random
      render text: encode(string_params) { generate_random_string(string_params[:count]) }
    end

    private

    def default_params
      default_caching_params.merge(
        base64: false,
        gzip: false,
      )
    end

    def string_params
      caching_params.permit(:base64, :gzip)
    end
  end
end

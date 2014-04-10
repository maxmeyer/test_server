# encoding: utf-8
module TestServer
  class StreamingController < ApplicationController
    include ActionController::Live

    before do
      content_type 'text/plain'
      params.merge! default_params
    end

    def index
      redirect_to action: 'string'
    end

    def string
      response.stream.write(
        encode(string_params) { "Data #{string_params[:count]} times repeated" }
      )

      string_params[:count].times do |n|
        response.stream.write(
          encode(string_params) { "#{n + 1}: data" }
        )
        sleep 1
      end

      response.stream.close
    end

    def eicar
      generate_eicar.each do |c|
        response.stream.write(
          encode(eicar_params) { c }
        )
      end

      response.stream.close
    end

    private

    def string_params
      caching_params.permit(:count, :base64, :gzip)
    end

    def eicar_params
      caching_params.permit(:base64, :gzip)
    end

    def default_params
      default_caching_params.merge(
        count: 1,
        base64: false,
        gzip: false,
      )
    end
  end
end

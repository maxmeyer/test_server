# encoding: utf-8
module TestServer
  module App
    class StringController < ApplicationController

      before do
        param :no_cache, Boolean, default: false
        param :must_revalidate, Boolean, default: false
        param :max_age, Integer
        param :base64, Boolean, default: false

        configure_caching(params)
      end

      get '/' do
        redirect to('/default/')
      end

      get '/default/?:count?' do
        param :count, Integer, default: 1

        encode do
          generate_string(params[:count])
        end
      end

      get '/eicar/' do
        encode do
          generate_eicar.join
        end
      end

      get '/sleep/?:count?' do
        param :count, Integer, default: 120
        sleep params[:count]

        encode do
          generate_string(1)
        end
      end

      get '/random/?:count?' do
        param :count, Integer, default: 10

        encode do
          generate_random_string(params[:count])
        end
      end
    end
  end
end

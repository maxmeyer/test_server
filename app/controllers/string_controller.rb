# encoding: utf-8
module TestServer
  module App
    class StringController < ApplicationController
      get '/' do
        redirect to('/default/')
      end

      get '/default/?:count?' do
        param :count, Integer, default: 1

        param :no_cache, String
        param :must_revalidate, String
        param :max_age, Integer

        configure_caching(params)

        generate_string(params[:count])
      end

      get '/eicar/' do
        param :no_cache, String
        param :must_revalidate, String
        param :max_age, Integer

        configure_caching(params)

        generate_eicar.join
      end

      get '/sleep/?:count?' do
        param :count, Integer, default: 120

        param :no_cache, String
        param :must_revalidate, String
        param :max_age, Integer

        configure_caching(params)

        sleep params[:count]

        generate_string(1)
      end
    end
  end
end

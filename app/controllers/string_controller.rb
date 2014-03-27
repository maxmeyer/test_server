# encoding: utf-8
module TestServer
  module App
    class StringController < ApplicationController
      get '/' do
        redirect '/default/'
      end

      get '/default/?:count?' do
        param :count, Integer, default: 1

        generate_string(params[:count])
      end

      get '/no-caching/?:count?' do
        param :count, Integer, default: 1

        cache_control :no_cache, :must_revalidate

        generate_string(params[:count])
      end

      get '/expires/?:timeout?' do
        param :timeout, Integer, default: 500
        param :count, Integer, default: 1

        expires params[:timeout], :public, :must_revalidate

        generate_string(params[:count])
      end

      get '/eicar/' do
        generate_eicar.join
      end

      get '/sleep/?:count?' do
        param :count, Integer, default: 120

        sleep params[:count]

        generate_string(1)
      end

      get '/no-caching/sleep/?:count?' do
        cache_control :no_cache, :must_revalidate
        param :count, Integer, default: 120

        sleep params[:count]

        generate_string(1)
      end
    end
  end
end

# encoding: utf-8
module TestServer
  module App
    class PlainController < ApplicationController

      helpers Sinatra::Param

      get '/?:count?' do
        param :count, Integer, default: 1
        param :cache_control, String

        configure_caching(params[:cache_control])

        "Plain Data\n" * params[:count]
      end
    end
  end
end

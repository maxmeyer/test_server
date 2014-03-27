# encoding: utf-8
module TestServer
  module App
    class PlainController < ApplicationController

      helpers Sinatra::Param

      get '/?:count?' do
        param :count, Integer, default: 1
        count = params[:count]

        "Plain Data\n" * count
      end
    end
  end
end

# encoding: utf-8
module TestServer
  module App
    class TestController < ApplicationController

      helpers Sinatra::Streaming
      helpers Sinatra::Param

      configure do
        mime_type :stream, 'text/stream'
      end

      get '/stream/?:count?' do
        param :count, Integer, default: 10

        count = params[:count]

        content_type :stream

        stream do |out|
          out << "Data #{count} times repeated\n"

          count.times do |n|
            out << "#{n + 1}: data\n"
            sleep 1
          end
        end
      end
    end
  end
end

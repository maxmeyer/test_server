# encoding: utf-8
module TestServer
  module App
    class StreamingController < ApplicationController
      helpers Sinatra::Streaming

      helpers do
        def stream_data(&block)
          content_type :stream
          cache_control :no_cache, :must_revalidate

          stream(&block)
        end
      end

      configure do
        mime_type :stream, 'text/plain'
      end

      get '/' do
        redirect to('/default/')
      end

      get '/default/?:count?' do
        param :count, Integer, default: 10

        count = params[:count]

        stream_data do |out|
          out << "Data #{count} times repeated\n"

          count.times do |n|
            out << "#{n + 1}: data\n"
            sleep 1
          end
        end
      end

      get '/eicar/' do
        stream_data do |out|
          generate_eicar.each do |c|
            out << c
          end
        end
      end
    end
  end
end

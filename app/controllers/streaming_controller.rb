# encoding: utf-8
module TestServer
  module App
    WebApp.controller :streaming do
      helpers Sinatra::Streaming

      before do
        param :base64, Boolean, default: false
      end

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

      get :index, map: '/' do
        redirect to('/default/')
      end

      get :string, map: '/default' do
        param :count, Integer, default: 10

        count = params[:count]

        stream_data do |out|
          out << encode { "Data #{count} times repeated" }

          count.times do |n|
            out << encode { "#{n + 1}: data" }
            sleep 1
          end
        end
      end

      get :eicar, map: '/eicar' do
        stream_data do |out|
          generate_eicar.each do |c|
            out << encode { c }
          end
        end
      end
    end
  end
end

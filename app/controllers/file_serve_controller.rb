module TestServer
  module App
    class FileServeController < ApplicationController
      helpers Sinatra::Param

      get '/' do
        redirect to('/proxy.pac')
      end

      get '/:name' do
        param :name, String, required: true

        content_type :proxy_pac_file

        name = translation_table.rewrite(env['REMOTE_ADDR'], params[:name])

        file = local_storage.find(name)
        fail Sinatra::NotFound, name if file.nil?

        file.compressed_content 
      end
    end
  end
end

# encoding: utf-8
module TestServer
  module App
    class JavascriptController < ApplicationController

      before do
        param :no_cache, Boolean, default: false
        param :must_revalidate, Boolean, default: false
        param :max_age, Integer
        param :base64, Boolean, default: false

        configure_caching(params)
      end
      get '/xhr/string' do
        param :count, Integer, default: 10
        param :timeout, Integer, default: 10_000
        param :url, String

        @count   = params[:count]
        @url     = params[:url]
        @timeout = params[:timeout]

        #@data = encode do
        #  generate_string(params[:count])
        #end

        haml :'xhr/show', layout: :application
      end
    end
  end
end

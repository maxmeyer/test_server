# encoding: utf-8
module TestServer
  module App
    class JavascriptController < ApplicationController
      #use Rack::Cors do 
      #  allow do
      #    origins '*'
      #    resource '*', :headers => :any, :methods => [:get, :post]
      #  end
      #end

      before do
        param :no_cache, Boolean, default: false
        param :must_revalidate, Boolean, default: false
        param :max_age, Integer
        param :base64, Boolean, default: false

        configure_caching(params)
      end

      get :url, map: '/xhr/url' do
        param :count, Integer, default: 10
        param :timeout, Integer, default: 1_000
        param :url, String
        param :repeat, String, default: 'false'

        @count   = params[:count]
        @url     = params[:url]
        @timeout = params[:timeout]
        @repeat  = %w{ on yes true t }.include?(params[:repeat])

        render 'xhr/show', layout: :application
      end
    end
  end
end

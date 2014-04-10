# encoding: utf-8
module TestServer
  module App
    class ApplicationController < ActionController::Base
      include TestServer::WebHelper

      # Prevent CSRF attacks by raising an exception.
      # For APIs, you may want to use :null_session instead.
      protect_from_forgery with: :exception
    end
  end
end

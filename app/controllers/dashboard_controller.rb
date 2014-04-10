# encoding: utf-8
module TestServer
  module App
    class DashboardController < ApplicationController
      get :index, map: '/' do
        render 'dashboard/index', layout: :application
      end
    end
  end
end

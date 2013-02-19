require 'sinatra'
require 'rest-client'
require 'json'

require 'therry/metrics'
require 'therry/values'

module Therry
  class Web < Sinatra::Base

    before do
      if request.accept.include?("application/json")
        content_type "application/json"
        status 200
      else
        halt 400
      end
    end

    get '/' do
      Metric.all.to_json
    end

    get '/search/?' do
      Metric.find(params[:pattern]).to_json
    end

    get '/values/?' do # values for last hour, by default
      Value.top_n(params[:pattern], :n => params[:n]).to_json
    end

    get '/health/?' do
      {:status => 'OK', :count => Metric.all.count}.to_json
    end
  end
end

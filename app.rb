ENV['RACK_ENV'] ||= 'development'

require 'bundler'
Bundler.require :default, ENV['RACK_ENV'].to_sym

require_relative 'services/github_search_service'

class Application < Sinatra::Base
  get '/' do
    @search_text, @page = params['search_text'], params['page']

    service = GithubSearchService.new(@search_text, @page)
    service.call

    @result, @error = service.result, service.error
    erb :index
  end
end

Application.start!

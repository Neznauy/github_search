ENV['RACK_ENV'] ||= 'development'

require 'bundler'
Bundler.require :default, ENV['RACK_ENV'].to_sym

class Application < Sinatra::Base
  get '/' do
    erb :index
  end
end

Application.start!

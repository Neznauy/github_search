require 'rack/test'
require 'rspec'

ENV['RACK_ENV'] = 'test'

Dir[Pathname(__FILE__).dirname.join('shared_examples/**/*.rb').to_s].each { |file| require file }

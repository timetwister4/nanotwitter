ENV['RACK_ENV'] = 'test'

require_relative '../app.rb'
require_relative '../config/config_sinatra.rb'
require 'minitest/autorun'
require 'rack/test'
require 'redis'

ActiveRecord::Migration.maintain_test_schema!

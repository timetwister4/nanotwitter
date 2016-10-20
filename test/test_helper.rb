ENV['RACK_ENV'] = 'test'

require_relative '../app'
require_relative '../config/config_sinatra.rb'
require 'minitest/autorun'
require 'rack/test'

ActiveRecord::Migration.maintain_test_schema!

# These Settings Establish the Proper Database Connection for Heroku Postgres
# The environment variable DATABASE_URL should be in the following format:
#     => postgres://{user}:{password}@{host}:{port}/path
# This is automatically configured on Heroku, you only need to worry if you also
# want to run your app locally

require 'byebug'

puts "[Env: #{ENV['RACK_ENV']}.#{ENV['RAILS_ENV']}.#{ENV['SINATRA_ENV']}]"

configure :development do
  puts "[running in development mode]"
  ActiveRecord::Base.establish_connection(
    :adapter => :sqlite3,
    :database =>  "db/development.sqlite3.db"
  )
end

configure :production do
  puts "[running in production mode]"
  ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])
end

configure :test do
  puts "[running in test mode]"
  ActiveRecord::Base.establish_connection(
    :adapter => 'sqlite3',
    :database =>  'db/test.sqlite3.db'
  )
end

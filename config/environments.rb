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
  db = URI.parse(ENV['DATABASE_URL'] || 'postgres://localhost/mydb')

  ActiveRecord::Base.establish_connection(
    :adapter => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
    :host     => db.host,
    :username => db.user,
    :password => db.password,
    :datbase => db.path[1..-1],
    :encoding => 'utf8'
  )
end

configure :test do
  puts "[running in test mode]"
  ActiveRecord::Base.establish_connection(
    :adapter => 'sqlite3',
    :database =>  'db/test.sqlite3.db'
  )
end

require 'rabbitmq_service_util'
require "bunny"

conn = Bunny.new(RabbitMQ::amqp_connection_url)
conn.start

ch   = conn.create_channel
q    = ch.queue("hello")

ch.default_exchange.publish("Hello World!", :routing_key => q.name)
puts " [x] Sent 'Hello World!'"

conn.close

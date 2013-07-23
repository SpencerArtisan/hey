require 'hey'
require 'database'
include Database

Database.node = '127.0.0.1:9160'
Database.keyspace = 'hey_prod'

puts Hey.new.execute ARGV

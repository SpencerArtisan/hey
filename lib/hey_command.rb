require 'hey'
require 'database'
include Database

Database.node = '192.168.1.100:9160'
Database.keyspace = 'hey_prod'

puts Hey.new.execute ARGV

require 'hey'
require 'database'
require 'memory'

Database.node = '192.168.1.100:9160'
Database.keyspace = 'hey_prod'
Memory.db Database.db

puts Hey.new.execute ARGV

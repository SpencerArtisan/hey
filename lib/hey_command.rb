require 'hey'
require 'cassandra_orm/database'
require 'memory'

Memory.database CassandraORM::Database.database('192.168.1.100:9160', 'hey_prod')

puts Hey.new.execute ARGV

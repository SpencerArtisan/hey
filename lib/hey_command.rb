require 'hey'
require 'cassandra_orm/database'
require 'memory'

Memory.database CassandraORM::Database.database('127.0.0.1:9160', 'hey_prod')

puts Hey.new.execute ARGV

require 'hey'
require 'cassandra_orm/database'
require 'memory'

CassandraORM::Database.node = '192.168.1.100:9160'
CassandraORM::Database.keyspace = 'hey_prod'
Memory.database CassandraORM::Database.database

puts Hey.new.execute ARGV

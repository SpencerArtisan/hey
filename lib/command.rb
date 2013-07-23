require 'cassandra'
require 'cassandra-cql'

db = CassandraCQL::Database.new '127.0.0.1:9160', keyspace: 'hey'

db.execute('select * from memory').fetch { |row| puts row.to_hash.inspect }

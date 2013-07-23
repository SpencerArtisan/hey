require 'cassandra'
require 'cassandra-cql'

db = CassandraCQL::Database.new '127.0.0.1:9160', keyspace: 'hey'

db.execute "DROP COLUMNFAMILY memory"
db.execute "CREATE COLUMNFAMILY memory (id varchar PRIMARY KEY, description varchar, priority varchar, state varchar)"

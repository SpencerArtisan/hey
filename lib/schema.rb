require 'cassandra'
require 'cassandra-cql'
require 'database'
include Database

#db.execute("CREATE KEYSPACE hey_prod WITH strategy_class='org.apache.cassandra.locator.SimpleStrategy' AND strategy_options:replication_factor=1")

Database.keyspace = 'hey_prod'
#db.execute "DROP COLUMNFAMILY memory"
db.execute "CREATE COLUMNFAMILY memory (id varchar PRIMARY KEY, description varchar, priority varchar, state varchar)"

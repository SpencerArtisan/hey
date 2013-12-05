require 'environment'
include CassandraORM::Database

#db.execute("CREATE KEYSPACE hey_prod WITH strategy_class='org.apache.cassandra.locator.SimpleStrategy' AND strategy_options:replication_factor=1")

#CassandraORM::Database.keyspace = 'hey'
#db.execute "DROP COLUMNFAMILY memory"
#db.execute "CREATE COLUMNFAMILY memory (id varchar PRIMARY KEY, description varchar, priority varchar, state varchar, appear date, completed date)"
#CassandraORM::Database.database.execute "ALTER COLUMNFAMILY memory ADD appear_on timestamp"
CassandraORM::Database.database.execute "ALTER COLUMNFAMILY memory ADD completed_on timestamp"

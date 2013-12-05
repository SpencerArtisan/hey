require 'cassandra_orm/database'

#db.execute("CREATE KEYSPACE hey_prod WITH strategy_class='org.apache.cassandra.locator.SimpleStrategy' AND strategy_options:replication_factor=1")

CassandraORM::Database.database '127.0.0.1:9160', 'hey'
#CassandraORM::Database.database.execute "DROP COLUMNFAMILY memory"
CassandraORM::Database.database.execute "CREATE COLUMNFAMILY memory (id varchar PRIMARY KEY, description varchar, priority varchar, state varchar, appear_on timestamp, completed_on timestamp)"
#CassandraORM::Database.database.execute "ALTER COLUMNFAMILY memory ADD appear_on timestamp"
#CassandraORM::Database.database.execute "ALTER COLUMNFAMILY memory ADD completed_on timestamp"

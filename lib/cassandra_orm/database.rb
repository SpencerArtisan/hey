require 'cassandra-cql'

module CassandraORM
  module Database
    def self.database node = nil, keyspace = nil
      @node = node if node
      @keyspace = keyspace if keyspace
      CassandraCQL::Database.new @node, keyspace: @keyspace
    end
  end
end

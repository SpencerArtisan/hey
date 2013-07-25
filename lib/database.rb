module CassandraORM
  module Database
    def self.node
      @node ||= '192.168.1.100:9160'
    end

    def self.node= address
      @node ||= address
    end

    def self.keyspace
      @keyspace ||= 'hey'
    end

    def self.keyspace= name
      @keyspace ||= name
    end

    def self.database
      CassandraCQL::Database.new node, keyspace: keyspace
    end
  end
end

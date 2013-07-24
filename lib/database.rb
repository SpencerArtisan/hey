module Database
  def node
    @@node ||= '127.0.0.1:9160'
  end

  def node= address
    @@node ||= address
  end

  def keyspace
    @@keyspace ||= 'hey'
  end

  def keyspace= name
    @@keyspace ||= name
  end

  def db
    CassandraCQL::Database.new node, keyspace: keyspace
  end
end
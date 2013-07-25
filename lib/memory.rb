require 'cassandra_orm/persistable'

class Memory
  include CassandraORM::Persistable
  attr_accessor :description, :state, :priority
  defaults state: 'Not started', priority: 'Medium'
end

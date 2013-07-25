require 'persistable'
require 'database'

class Memory
  include CassandraORM::Persistable
  attr_accessor :description, :state, :priority
  defaults state: 'Not started', priority: 'Medium'
end

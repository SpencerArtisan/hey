require 'cassandra_orm/persistable'

class Memory
  include CassandraORM::Persistable
  attr_accessor :description, :state, :priority, :group, :completed_on, :appear_on
  defaults state: 'Not started', priority: 'Medium'

  def complete
    update state: 'complete', completed_on: Time.now
  end
end

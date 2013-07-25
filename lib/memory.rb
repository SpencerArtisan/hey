require 'persistable'

class Memory
  include CassandraORM::Persistable
  attr_accessor :description, :state, :priority
  defaults state: 'Not started', priority: 'Medium'

  def to_s
    "#{id}. #{description}"
  end
end

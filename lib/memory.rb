require 'cassandra'
require 'cassandra-cql'
require 'database'
require 'ruby_ext'
require 'persistable'
include SimpleUUID
include Database

class Memory
  include CassandraORM::Persistable
  attr_accessor :description, :state, :priority, :id
  defaults state: 'Not started', priority: 'Medium'

  def to_s
    "#{id}. #{description}"
  end
end

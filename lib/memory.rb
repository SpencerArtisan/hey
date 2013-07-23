require 'cassandra'
require 'cassandra-cql'
require 'memory_set'
require 'database'
include SimpleUUID
include Database

class Memory
  attr_accessor :description, :state, :priority, :id

  def initialize params = {}
    params = params.map {|k,v| {k.to_sym => v}}.reduce :merge
    params ||= {}
    self.description = params[:description]
    self.state = params[:state]
    self.priority = params[:priority]
    self.id = params[:id]
  end

  def self.all
    all = MemorySet.new
    db.execute('select * from memory').fetch_hash{ |row| all << Memory.new(row) }
    all
  end

  def self.delete_all
    db.execute 'truncate memory'
  end

  def self.create params = {}
    memory = Memory.new params
    id = CassandraCQL::UUID.new.to_guid
    db.execute "insert into memory (id, description, state, priority) values ('#{id}', '#{memory.description}', '#{memory.state}', '#{memory.priority}')"
  end
end

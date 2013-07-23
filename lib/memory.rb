require 'cassandra'
require 'cassandra-cql'
require 'memory_set'
include SimpleUUID

class Memory
  attr_accessor :description, :state, :priority, :id, :number

  def initialize params = {}
    params = params.map {|k,v| {k.to_sym => v}}.reduce :merge
    params ||= {}
    self.description = params[:description]
    self.state = params[:state]
    self.priority = params[:priority]
    self.id = params[:id]
    self.number = params[:number]
  end

  def summary
    "#{number}. #{description}"
  end

  def self.all
    all = MemorySet.new
    db.execute('select * from memory').fetch_hash{ |row| all << Memory.new(row) }
    all
  end

  def self.delete_all
    db.execute 'truncate memory'
  end

  def save
    id = CassandraCQL::UUID.new.to_guid
    Memory.db.execute "insert into memory (id, description, state, priority) values ('#{id}', '#{description}', '#{state}', '#{priority}')"
  end

  def self.db
    CassandraCQL::Database.new '127.0.0.1:9160', keyspace: 'hey'
  end
end

require 'cassandra'
require 'cassandra-cql'
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
    all = []
    db.execute('select * from memory').fetch_hash{ |row| all << Memory.new(row) if row.length > 1 }
    all.sort {|x, y| x.description <=> y.description}
  end

  def delete
    db.execute "delete from memory where id='#{id}'"
  end

  def update params
    updates = params.map{|name, value| "#{name}='#{value}'"}.join ','
    db.execute "update memory set #{updates} where id='#{id}'"
  end

  def self.delete_all
    db.execute 'truncate memory'
  end

  def self.create params = {}
    memory = Memory.new params
    id = CassandraCQL::UUID.new.to_guid
    db.execute "insert into memory (id, description, state, priority) values ('#{id}', '#{memory.description}', '#{memory.state}', '#{memory.priority}')"
  end

  def to_s
    "#{id}. #{description}"
  end
end

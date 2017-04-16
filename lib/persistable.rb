require 'ruby_ext'
require 'json'

module Persistable
  FILE = ".tasks.json"
  attr_accessor :id
  alias_static_method :tasks, :save, :retrieve, :create

  def initialize params = {}
    params = self.class.defaults.merge(params) if self.class.defaults
    params.each {|k,v| send("#{k}=", v)}
  end

  def update params
    oldtask = tasks.find{|task| task['id'] == id}
    delete
    create oldtask.merge(params)
  end

  def delete
    save tasks.delete_if{|task| task['id'] == id}
  end

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    attr_simple_accessor :defaults

    def tasks
      file = File.open(FILE, "r")
      json = file.read
      JSON.parse(json)['tasks']
    rescue
      []
    end

    def save newtasks
      json = JSON.generate({'tasks' => newtasks})
      file = File.open(FILE, "w")
      file.puts json
      file.close
    end

    def all
      tasks.map{|params| new(params) }
    end

    def [] index
      self.all[index]
    end

    def retrieve id
      result = tasks.find{|task| task['id'] == id}
      result == nil ? nil : new(result)
    end

    def create params = {}
      params = assign_id params
      save tasks.push(params)
      new params
    end

    def delete_all
      file = File.open(FILE, "w")
      file.puts ""
      file.close
    end

    def assign_id params
      id = SimpleUUID::UUID.new.to_guid
      {'id' => id}.merge params
    end
  end
end

module CassandraORM
  module Persistable
    def initialize params = {}
      params = self.class.defaults.merge(params) unless self.class.defaults.nil?
      params.each {|k,v| instance_eval("self.#{k} = '#{v}'")}
    end

    def delete
      db.execute "delete from #{column_family} where id='#{id}'"
    end

    def update params
      updates = params.map{|name, value| "#{name}='#{value}'"}.join ','
      db.execute "update #{column_family} set #{updates} where id='#{id}'"
      self.class.retrieve id
    end

    def column_family
      self.class.column_family
    end

    def self.included(base)                                                         
      base.extend ClassMethods
    end

    module ClassMethods
      def defaults params = nil
        return @defaults unless params
        @defaults = params
      end

      def all
        all = []
        db.execute("select * from #{column_family}").fetch_hash{ |row| all << new(row) if row.length > 1 }
        all
      end

      def [] index
        self.all[index]
      end

      def retrieve id
        new db.execute("select * from #{column_family} where id=?", id).fetch_row.to_hash
      end

      def delete_all
        db.execute "truncate #{column_family}"
      end

      def create params = {}
        id = CassandraCQL::UUID.new.to_guid
        params = {id: id}.merge params
        columns = params.keys.join ','
        values = params.values.map {|value| "'#{value}'"}.join ','
        db.execute "insert into #{column_family} (#{columns}) values (#{values})"
        retrieve id
      end

      def column_family
        name.downcase
      end
    end
  end
end

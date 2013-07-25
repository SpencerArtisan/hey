require 'cassandra_orm/persistable'

module CassandraORM
  class TestPersistable
    include Persistable
    attr_accessor :field1, :field2
    defaults field1: 'default1'
  end

  describe Persistable do
    let (:database) { stub }

    before do
      TestPersistable.database database
      CassandraCQL::UUID.stub new: (stub to_guid: 'a guid')
    end

    describe '#new' do
      it 'should have properties set' do
        subject = TestPersistable.new id: 'an id', field1: 'field1', field2: 'field2'
        expect(subject.id).to eq 'an id'
        expect(subject.field1).to eq 'field1'
        expect(subject.field2).to eq 'field2'
      end

      it 'should have defaults' do
        subject = TestPersistable.new
        expect(subject.field1).to eq('default1')
        expect(subject.field2).to be_nil
      end
    end

    describe '#create' do
      it 'should be saved to the database' do
        database.should_receive(:execute).with "INSERT INTO testpersistable (id,field1,field2) VALUES ('a guid','field1','field2')"
        TestPersistable.create field1: 'field1', field2: 'field2'
      end
    end

    describe '#update' do
      it 'should be updated in the database' do
        database.should_receive(:execute).with "UPDATE testpersistable SET field1='new field1',field2='new field2' WHERE id='a guid'"
        subject = TestPersistable.new id: 'a guid'
        subject.update field1: 'new field1', field2: 'new field2'
      end
    end

    describe '#delete' do
      it 'should be deletable' do
        database.should_receive(:execute).with "DELETE FROM testpersistable WHERE id='a guid'"
        subject = TestPersistable.new id: 'a guid'
        subject.delete
      end
    end
  end
end

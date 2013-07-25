require 'persistable'

module CassandraORM
  class TestPersistable
    include Persistable
    attr_accessor :field1, :field2
    defaults field1: 'default1'

  end

  describe Persistable do
    before do
      TestPersistable.apply_schema db
      TestPersistable.delete_all
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
        #expect(subject.id).not_to be_nil
      end
    end

    describe '#create' do
      it 'should be saved to the database' do
        TestPersistable.create field1: 'field1', field2: 'field2'
        subject = TestPersistable[0]
        expect(subject.field1).to eq('field1')
        expect(subject.field2).to eq('field2')
      end

      context 'multiple item persistence' do
        it 'should create multiple memories' do
          TestPersistable.create field1: 'first'
          TestPersistable.create field1: 'second'
          expect(TestPersistable.all).to have(2).items
        end

        it 'should create with unique ids' do
          TestPersistable.create field1: 'first'
          TestPersistable.create field1: 'second'
          expect(TestPersistable[0].id).not_to eq(TestPersistable[1].id)
        end
      end
    end

    describe '#update' do
      it 'should be updated in the database' do
        subject = TestPersistable.create field1: 'field1', field2: 'field2'
        subject.update field1: 'new field1', field2: 'new field2'
        subject = TestPersistable[0]
        expect(subject.field1).to eq('new field1')
        expect(subject.field2).to eq('new field2')
      end
    end

    describe '#delete' do
      it 'should be deletable' do
        TestPersistable.create(field1: 'field1').delete
        expect(TestPersistable.all).to be_empty
      end
    end
  end
end

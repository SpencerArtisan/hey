require 'memory'

describe Memory do
  before do
    Memory.delete_all
  end

  context 'basic functionality' do
    subject { Memory.new description: 'a description', state: 'a state', priority: 'a priority' }

    its (:description) { should == 'a description' }
    its (:state) { should == 'a state' }
    its (:priority) { should == 'a priority' }
  end

  context 'creation' do
    subject do
      Memory.create description: 'a description', state: 'a state', priority: 'a priority'
      Memory.all[0]
    end

    its (:description) { should == 'a description' }
    its (:state) { should == 'a state' }
    its (:priority) { should == 'a priority' }
  end

  context 'update' do
    subject do
      Memory.create description: 'a description', state: 'a state', priority: 'a priority'
      Memory.all[0]
    end

    its (:description) { should == 'a description' }
    its (:state) { should == 'a state' }
    its (:priority) { should == 'a priority' }
  end

  context 'multiple item persistence' do
    it 'should create multiple memories' do
      Memory.create
      Memory.create
      Memory.all.should have(2).item
    end

    it 'should create with unique ids' do
      Memory.create
      Memory.create
      Memory.all[0].id.should_not == Memory.all[1].id
    end
  end
end

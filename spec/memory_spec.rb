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

  context 'attribute persistence' do
    subject do
      memory = Memory.new description: 'a description', state: 'a state', priority: 'a priority'
      memory.save 
      memories = Memory.all[0]
    end

    its (:description) { should == 'a description' }
    its (:state) { should == 'a state' }
    its (:priority) { should == 'a priority' }
  end

  context 'multiple item persistence' do
    it 'should save multiple memories' do
      Memory.new.save
      Memory.new.save
      Memory.all.should have(2).item
    end

    it 'should save with unique ids' do
      Memory.new.save
      Memory.new.save
      Memory.all[0].id.should_not == Memory.all[1].id
    end
  end
end

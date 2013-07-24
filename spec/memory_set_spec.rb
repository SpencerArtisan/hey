require 'memory_set'

describe MemorySet do
  let(:memory) { stub }

  it 'should be a singleton object' do
    Memory.should_receive(:all).and_return [memory]
    MemorySet.instance[0].should == memory
  end

  it 'should allow creation of a new memory' do
    Memory.should_receive(:create).with description: 'a memory'
    MemorySet.new.create 'a memory'
  end

  it 'should display a list of numbered memories' do
    memory_set = MemorySet.new [stub(description: 'first').as_null_object,
                                stub(description: 'second').as_null_object]
    memory_set.to_s.should == " 0. first\n 1. second"
  end

  it 'should not show completed memories' do
    memory_set = MemorySet.new [stub(description: 'first', state: 'complete')]
    memory_set.to_s.should be_empty
  end

  it 'should highlight high priority tasks' do
    memory_set = MemorySet.new [stub(description: 'first', priority: 'high').as_null_object]
    memory_set.to_s.should == "*0. first"
  end

  it 'should allow updating a memory' do
    update_params = stub
    Memory.stub all: [memory]
    memory.should_receive(:update).with update_params
    MemorySet.instance.update 0, update_params
  end

  it 'should allow deletion of a memory' do
    Memory.stub all: [memory]
    memory.should_receive :delete
    MemorySet.instance.delete 0
  end
end

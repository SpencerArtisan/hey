require 'memory_set'

describe MemorySet do
  it 'should be a singleton object' do
    memory = stub
    Memory.should_receive(:all).and_return [memory]
    MemorySet.instance[0].should == memory
  end

  it 'should display a list of numbered memories' do
    memory_set = MemorySet.new [stub(description: 'first'), stub(description: 'second')]
    memory_set.to_s.should == "1. first\n2. second"
  end

  it 'should allow creation of a new memory' do
    Memory.should_receive(:create).with description: 'a memory'
    MemorySet.new.create 'a memory'
  end
end

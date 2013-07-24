require 'hey'

describe Hey do
  let (:hey) { Hey.new }
  let (:memory_set) { stub }

  before do
    MemorySet.stub instance: memory_set
  end

  it 'should retrieve a list of item' do
    memory_set.stub to_s: 'memory set'
    hey.execute([]).should == 'memory set'
  end

  it 'should create a new item' do
    memory_set.should_receive(:create).with 'task'
    hey.execute %w{task}
  end
  
  it 'should create a new multi-word item' do
    memory_set.should_receive(:create).with 'multi word task'
    hey.execute %w{multi word task}
  end

  it 'should delete an item' do
    memory_set.should_receive(:delete).with 1
    hey.execute %w{-d 1}
  end

  it 'should mark a task as high priority' do
    memory_set.should_receive(:update).with 1, :priority => :high
    hey.execute %w{-h 1}
  end

  it 'should mark a task as complete' do
    memory_set.should_receive(:update).with 1, :status => :complete
    hey.execute %w{-c 1}
  end

  it 'should provide help' do
    hey.execute(%w{-help}).should_not be_nil
  end
end

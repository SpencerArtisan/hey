require 'hey'

describe Hey do
  let (:hey) { Hey.new }
  let (:memory_set) { double.as_null_object }

  before do
    MemorySet.stub new: memory_set
  end

  it 'should retrieve a list of the main items' do
    memory_set.stub to_colourful_s: 'memory set'
    expect(hey.execute([])).to eq('memory set')
  end

  it 'should retrieve a list of all items' do
    memory_set.stub to_colourful_s_full: 'memory set'
    expect(hey.execute(%w{-f})).to eq('memory set')
  end

  it 'should create a new low priority item' do
    memory_set.should_receive(:create).with 'task', priority: 'low'
    hey.execute %w{-l task}
  end
  
  it 'should create a new high priority item' do
    memory_set.should_receive(:create).with 'task', priority: 'high'
    hey.execute %w{-p task}
  end
  
  it 'should create a new item' do
    memory_set.should_receive(:create).with 'task', {}
    hey.execute %w{task}
  end

  it 'should create a new multi-word item' do
    memory_set.should_receive(:create).with 'multi word task', {}
    hey.execute %w{multi word task}
  end

  it 'should delete an item' do
    memory_set.should_receive(:delete).with 1
    hey.execute %w{-d 1}
  end

  it 'should mark a task as low priority' do
    memory_set.should_receive(:update).with 1, priority: 'low'
    hey.execute %w{-l 1}
  end

  it 'should mark a task as high priority' do
    memory_set.should_receive(:update).with 1, priority: 'high'
    hey.execute %w{-p 1}
  end

  it 'should mark a task as complete' do
    memory_set.should_receive(:update).with 1, state: 'complete'
    hey.execute %w{-c 1}
  end

  it 'should provide help' do
    expect(hey.execute(%w{-h})).to_not be_nil
  end
end

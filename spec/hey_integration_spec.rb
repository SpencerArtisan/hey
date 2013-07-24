require 'hey'
require 'memory'

describe Hey do
  let (:hey) { Hey.new }

  before { Memory.delete_all }

  it 'should retrieve an empty list of items' do
    hey.execute([]).should be_empty
  end

  it 'should retrieve a list of items' do
    hey.execute %w{task 1}
    hey.execute %w{task 2}
    hey.execute([]).should == " 0. task 1\n 1. task 2"
  end

  it 'should create a new item' do
    hey.execute %w{task}
  end
  
  it 'should create a new multi-word item' do
    hey.execute %w{multi word task}
  end

  it 'should delete an item' do
    hey.execute %w{task}
    hey.execute %w{-d 0}
  end

  it 'should mark a task as high priority' do
    hey.execute %w{task}
    hey.execute %w{-h 0}
  end

  it 'should mark a task as complete' do
    hey.execute %w{task}
    hey.execute %w{-c 0}
  end

  it 'should provide help' do
    hey.execute(%w{-help}).should_not be_nil
  end
end

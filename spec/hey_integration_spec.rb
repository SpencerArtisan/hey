# encoding: utf-8
require 'environment'
require 'hey'
require 'memory'

describe Hey do
  let (:hey) { Hey.new }

  before do
    Memory.database CassandraORM::Database.database
    Memory.delete_all
  end

  it 'should retrieve an empty list of items' do
    expect(hey.execute([])).to be_empty
  end

  it 'should retrieve a list of items' do
    hey.execute %w{task}
    expect(hey.execute([])).to eq(" 0. task".green)
  end

  it 'should create a new item' do
    hey.execute %w{task}
  end
  
  it 'should create a new low priority item' do
    hey.execute %w{-l task}
    expect(hey.execute(%w{-f})).to eq(" 0. task".yellow)
  end
  
  it 'should create a new high priority item' do
    hey.execute %w{-p task}
    expect(hey.execute([])).to eq(" 0. task".red)
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
    hey.execute %w{-p 0}
  end

  it 'should mark a task as complete' do
    hey.execute %w{task}
    hey.execute %w{-c 0}
  end

  it 'should provide help' do
    expect(hey.execute(%w{-h})).to_not be_nil
  end
end

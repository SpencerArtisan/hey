require 'rubygems'
require 'cassandra/1.0'
include SimpleUUID

client = Cassandra.new('hey', '127.0.0.1:9160')

client.insert(:memory, '1', {
  'description' => 'add memory',
  'state' =>  'Not started',
  'priority' =>  'Medium'
})

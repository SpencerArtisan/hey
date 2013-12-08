require 'sinatra'

configure do
    require 'redis'
    uri = URI.parse(ENV["REDISCLOUD_URL"])
    $redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
end

get '/' do 
  val = $redis.get("val")
  "Hello #{val}"
end

get '/blah' do
  $redis.set("val", "blah")
end

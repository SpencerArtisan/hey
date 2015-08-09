require 'ruby_ext'

puts "hello"
puts "hello".colour(33)

1.upto 80 do |v| 
  puts "hello #{v}".colour(v)
end


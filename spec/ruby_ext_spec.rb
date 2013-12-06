require 'ruby_ext'

describe 'Ruby extension' do
  it 'should convert strings to styled strings' do
    puts "Bold green".colour(1).green
    #1.upto(300) {|i| puts "#{i}. Hello".colour(i)}
  end
end

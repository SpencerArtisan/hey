require 'ruby_ext'

describe 'Ruby extension' do
  it 'should convert strings to styled strings' do
    1.upto(100) {|i| puts "#{i}. Hello".colour(i)}
  end
end

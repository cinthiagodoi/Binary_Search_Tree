
class Node
  attr_accessor :value, :right, :left
  def initialize(value = nil, right = nil, left = nil)
    @value = value
    @right = right
    @left = left  
  end
end
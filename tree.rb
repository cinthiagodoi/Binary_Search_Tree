require "./node.rb"
class Tree
  def initialize(values)
    @root = nil
    build_tree(values)
  end

  def build_tree(values)
    values = values.uniq
    values.each do |value|
      insert(value, @root)
    end
    self
  end

  def insert(value, node = nil)
    if node == nil 
      node = Node.new(value) 
      @root = node if @root == nil
      return
    end

    if value < node.value && node.left == nil  
      node.left = Node.new(value)
    elsif value > node.value && node.right == nil  
      node.right = Node.new(value)
    elsif value < node.value
      insert(value, node.left)
    else
      insert(value, node.right)
    end
  end 

  def find(value, node = @root)
    return nil if node.nil?
    if value < node.value
      find(value, node.left)
    elsif value > node.value
      find(value, node.right)
    else 
      return node
    end
  end

  def delete(value)
    node = find(value)
    if node != nil
      remove_node(node)
    end 
  end

  def remove_node(node)
    if node.left.nil? && node.right.nil?
      node = nil 
    elsif !node.left.nil? && node.right.nil?
      node = node.left
    elsif node.left.nil? && !node.right.nil?
      node = node.right
    else
      node = two_child(node)
    end
    node
  end

  def two_child(node)
    min_node = find_min(node.right)
    replace(min_node, node)
    remove(min_node)
  end

  def find_min(node)
    if node.left.nil?
      min_node = node
      return min_node
    else
      find_min(node.left)
    end
  end

  def replace(min_node, node)
    node.value = min_node.value
  end

  def remove(min_node)
    min_node = nil
  end

  def level_order(node = @root, result = [], level = 0)
    return result unless node
    result << [] if result.length == level
    result[level] << node.value
    level_order(node.left, result, level + 1)
    level_order(node.right, result, level + 1) 
  end

  def inoder(node = @root, nodes = [], &block)    
    return nodes if node.nil?
    inoder(node.left, nodes, &block)
    nodes.push(node.value)
    yield node
    inoder(node.right, nodes, &block)
    nodes
  end

  def preorder(node = @root, nodes = [], &block)
    return nodes if node.nil?
    nodes.push(node.value)
    yield node
    preorder(node.left, nodes, &block)
    preorder(node.right, nodes, &block)
    nodes
  end

  def postorder(node = @root, nodes = [], &block)
    return nodes if node.nil?
    postorder(node.left, nodes, &block)
    postorder(node.right, nodes, &block)
    nodes.push(node.value)
    yield node
    nodes
  end

  def depth(node = @root, counter = 0, value)
    while node != nil
      return counter if value == node.value
      value < node.value ? node = node.left : node = node.right
      counter +=1
    end
    counter 
  end

  def balanced?(node = @root)
    left_node = node.left
    right_node = node.right
    return(height(left_node) - height(right_node)).abs <= 1 
  end

  def height(node)
    if node.nil?
      return 0
    else
      left_node = height(node.left)
      right_node = height(node.right)
      return left_node > right_node ? left_node+1 : right_node+1
    end
  end

  def rebalance!
    values = inoder{|n| n.value}
    middle = values[values.size / 2]
    @root = Node.new(middle)
    build_tree(values)
  end
  
    
end                                                                                                                     



teste = Tree.new(Array.new(15){ rand(1..100)})
p teste.balanced?
p teste.level_order
p teste.preorder{|node| node.value }
p teste.inoder {|node| node.value}
p teste.postorder {|node| node.value}
teste.rebalance!
p teste.balanced?
p teste.level_order
p teste.preorder{|node| node.value }
p teste.inoder {|node| node.value}
p teste.postorder {|node| node.value}

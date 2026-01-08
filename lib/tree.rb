require_relative 'node'

# Tree class. It represents the Binary Search Tree builts from an ordered array
class Tree
  attr_accessor :array, :root

  def initialize(array)
    @array = array.sort.uniq
    @root = build_tree(@array)
  end

  def build_tree(array, start_point = 0, end_point = array.size - 1)
    mid_point = start_point + (end_point - start_point) / 2

    return nil if start_point > end_point

    root = Node.new(array[mid_point])
    root.left = build_tree(array, start_point, mid_point - 1)
    root.right = build_tree(array, mid_point + 1, end_point)
    root
  end

  def insert_node(number, node = @root)
    return node = Node.new(number) if node.nil?

    if number < node.value
      # go left
      node.left = insert_node(number, node.left)
    else
      # go right
      node.right = insert_node(number, node.right)
    end
    node
  end

  def min_value(node)
    # helper method to find the min value in the right subtree
    current = node
    current = current.left while current.left
    current.value
  end

  def delete_node(number, node = @root)
    return nil if node.nil?

    if number < node.value
      node.left = delete_node(number, node.left)
    elsif number > node.value
      node.right = delete_node(number, node.right)
    else # three possible case. No child, One child, Two children
      return node.right if node.left.nil?
      return node.left if node.right.nil?

      node.value = min_value(node.right)
      node.right = delete_node(node.value, node.right)
    end
    node
  end

  def insert_iterative(number)
    return @root = Node.new(number) if @root.nil?

    current = @root
    while current
      if number < current.value
        if current.left.nil?
          current.left = Node.new(number)
          break
        end
        current = current.left
      else
        if current.right.nil?
          current.right = Node.new(number)
          break
        end
        current = current.right
      end
    end
  end

  def find_recursive(number, node = @root)
    return nil if node.nil?
    return node if node.value == number

    if number < node.value
      find_recursive(number, node.left)
    else
      find_recursive(number, node.right)
    end
  end

  def find_iterative(number)
    current = @root
    while current
      return current if current.value == number

      current = if number < current.value
                  current.left
                else
                  current.right
                end
    end
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def level_order_iterative
    # implement a breadth first search BFS traversal using an iterative approach
    return [] if @root.nil?

    queue = [@root]
    result = []
    until queue.empty?
      current = queue.shift
      if block_given?
        yield current
      else
        result << current.value
      end
      queue << current.left if current.left
      queue << current.right if current.right
    end
    result unless block_given?
  end

  def inorder(node = @root, result = [], &block)
    # implement a depth first search DFS traversal using recursion. INORDER <LEFT> <ROOT> <RIGHT>
    return result if node.nil?

    inorder(node.left, result, &block)
    yield node if block_given?
    result << node.value
    inorder(node.right, result, &block)

    result
  end

  def preorder(node = @root, result = [], &block)
    # implement a depth first search DFS traversal using recursion. PREORDER <ROOT> <LEFT> <RIGHT>
    return result if node.nil?

    yield node if block_given?
    result << node.value
    preorder(node.left, result, &block)
    preorder(node.right, result, &block)

    result
  end

  def postorder(node = @root, result = [], &block)
    # implement a depth first search DFS traversal using recursion. POSTORDER <LEFT> <RIGHT> <ROOT>
    return result if node.nil?

    postorder(node.left, result, &block)

    postorder(node.right, result, &block)
    yield node if block_given?
    result << node.value

    result
  end

  def find_node_depth(value, node = @root, depth = 0)
    # find the depth of a node with given value
    return nil if node.nil?
    return depth if node.value == value

    if value < node.value
      find_node_depth(value, node.left, depth + 1)
    else
      find_node_depth(value, node.right, depth + 1)
    end
  end

  def find_node_height(value, node = @root)
    # find the height of a node with given value
    target_node = find_recursive(value, node)
    return height(target_node) unless target_node.nil?

    nil
  end

  def height(node)
    # helper method to calculate the height of a node
    return -1 if node.nil?

    1 + [height(node.left), height(node.right)].max
  end

  def balanced?(node = @root)
    # check if the tree is balanced
    return true if node.nil?

    left_height = height(node.left)
    right_height = height(node.right)

    # return false if the difference between the heights of left and right subtrees is > 1
    return false if (left_height - right_height).abs > 1

    # recurisively check if left and right subtrees are balanced
    balanced?(node.left) && balanced?(node.right)
  end

  def rebalance
    return if balanced?

    new_tree = inorder
    @root = build_tree(new_tree)
  end
end

tree = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324, 8000, 12])
tree.pretty_print
tree.insert_iterative(10)
tree.insert_iterative(167_200)
tree.insert_iterative(200_000)
tree.pretty_print
p tree.balanced?
p tree.rebalance
p tree.pretty_print
p tree.balanced?

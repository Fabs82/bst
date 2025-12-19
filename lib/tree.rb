require_relative 'node'

# Tree class. It represents the Binary Search Tree builts from an ordered array
class Tree
  attr_accessor :array, :root

  def initialize(array)
    @array = array.sort.uniq
    @root = build_tree(@array)
  end

  def build_tree(array, start_point = 0, end_point = array.size - 1)
    mid_point = (start_point + end_point) / 2

    return nil if start_point > end_point

    root = Node.new(array[mid_point])
    root.left = build_tree(array, start_point, mid_point - 1)
    root.right = build_tree(array, mid_point + 1, end_point)
    root
  end

  def insert_node(number, root = @root)
    return root = Node.new(number) if root.nil?

    if number < root.value
      # go left
      root.left = insert_node(number, root.left)
    else
      # go right
      root.right = insert_node(number, root.right)
    end
    root
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

tree = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])
tree.insert_node(8000)
tree.pretty_print

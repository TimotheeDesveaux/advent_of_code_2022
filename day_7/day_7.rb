#!/usr/bin/env ruby

FILE = 'input.txt'

class Directory
  attr_reader :parent

  def initialize(name, parent = nil)
    @name = name
    @children = []
    @parent = parent
  end

  def add_child(child)
    @children << child
  end

  def display(level = 0)
    print '  ' * level
    puts "- #{@name} (dir)"
    @children.each { |child| child.display(level + 1) }
  end

  def size
    size = 0
    @children.each { |child| size += child.size }
    size
  end

  def size_at_most(limit)
    res = []
    res << size if size <= limit
    @children.each { |child| res.concat child.size_at_most(limit) if child.is_a?(Directory) }
    res
  end

  def size_at_least(min)
    res = []
    res << size if size >= min
    @children.each { |child| res.concat child.size_at_least(min) if child.is_a?(Directory) }
    res
  end
end

class RegularFile
  attr_reader :size

  def initialize(name, size)
    @name = name
    @size = size
  end

  def display(level = 0)
    print '  ' * level
    puts "- #{@name} (file, size=#{@size})"
  end
end

def part_one(root)
  total_sizes = 0
  root.size_at_most(100_000).each { |size| total_sizes += size }
  total_sizes
end

def part_two(root)
  available_space = 70_000_000 - root.size
  needed_space = 30_000_000 - available_space
  min = 30_000_000
  root.size_at_least(needed_space).each { |size| min = size if size < min }
  min
end

if __FILE__ == $PROGRAM_NAME
  root = Directory.new('/')
  current = root

  File.foreach(FILE) do |line|
    if line.start_with?('$ cd ')
      name = line['$ cd '.length..].chomp

      case name
      when '/'
        current = root
      when '..'
        current = current.parent
      else
        new = Directory.new(name, current)
        current.add_child(new)
        current = new
      end
    else
      m = line.match(/(\d+) (.+)/)
      current.add_child(RegularFile.new(m[2], m[1].to_i)) if m
    end
  end

  puts "part one: #{part_one(root)}"
  puts "part two: #{part_two(root)}"
end

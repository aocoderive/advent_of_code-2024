#!/usr/bin/env ruby

require 'set'

INPUT = "input"

# Returns the input as an array of lines
def parse_as_lines path
  lines = []
  File.open(path, 'rb').each { |line| lines << line.chomp }
  lines
end

# Returns the input as an array or arrays of whitespace tokenized lines
def parse_as_tokens path
  lines = []
  File.open(path, 'rb').each { |line| lines << line.chomp.split }
  lines
end

# Returns the input as an array with each line the results of lambda.call(line)
def parse_as_custom path, &func
  data = []
  File.open(path, 'rb').each { |line| data << func.call(line) }
  data
end

def corrupt mem, loc
  row, col = loc
  mem[row][col] = '#'
end

def dump mem
  mem.each do |row|
    puts row.join
  end
end

def dump_path mem, path
  m = []
  mem.each do |row|
    m << row.dup
  end
  path.each do |row, col|
    m[row][col] = 'O'
  end
  m.each do |row|
    puts row.join
  end
end

class Node
  attr_accessor :row, :col, :parent, :g, :h, :f
  def initialize(row, col, parent, mem)
    @parent = parent
    @row = row
    @col = col
    @g = 0
    @h = (mem.size - row) + (mem[0].size - col)
    @f = 0
  end
  def ==(that)
    self.row == that.row and self.col == that.col
  end
  def eql?(that)
    self.row == that.row and self.col == that.col
  end
  def hash
    [row,col].hash
  end
end

def astar mem
  queue = []
  done = Set.new
  queue << Node.new(0, 0, nil, mem)
  while not queue.empty?
    node = queue.shift
    done << node
    if node.row == mem.size - 1 and node.col == mem[0].size - 1
      path = []
      while not node.nil?
        path << [node.row, node.col]
        node = node.parent
      end
      return path
    end

    row = node.row
    col = node.col
    [[row - 1, col], [row + 1, col], [row, col - 1], [row, col + 1]].each do |r,c|
      if r >= 0 and r < mem.size and c >= 0 and c < mem[0].size and mem[r][c] != '#'
        child = Node.new(r, c, node, mem)
        next if done.include?(child)
        do_add = true
        queue.each do |n|
          if child == n
            child = n
            do_add = false
            break
          end
        end
        queue << child if do_add

        if child.g.nil?
          child.parent = node
          child.g = node.g + 1
          child.f = child.g + child.h
        else
          g = node.g + child.g
          if g < child.g
            child.parent = node
            child.g = g
            child.f = child.g + child.h
          end
        end
      end
    end
    queue.sort! { |a, b| a.f <=> b.f }          
  end
  []
end

def part1
  # lines = parse_as_lines INPUT
  # tokens = parse_as_tokens INPUT
  w = 70
  h = 70
  memory = []
  (h + 1).times do 
    memory << ['.']*(w+1)
  end
  data = []
  parse_as_custom(INPUT) { |line|
    col,row = line.chomp.split(',').collect { |i| i.to_i }
    data << [row, col]
  }

  1024.times do |i|
    corrupt memory, data[i]
  end

  #dump memory
  path = astar(memory)
  #dump_path memory, path
  puts path.size - 1

end


def part2
  # lines = parse_as_lines INPUT
  # tokens = parse_as_tokens INPUT
  w = 70
  h = 70
  memory = []
  (h + 1).times do 
    memory << ['.']*(w+1)
  end
  data = []
  parse_as_custom(INPUT) { |line|
    col,row = line.chomp.split(',').collect { |i| i.to_i }
    data << [row, col]
  }

  data.each_with_index do |d, idx|
    row, col = d
    corrupt memory, [row, col]
    if idx > 1024
      path = astar(memory)
      if path.empty?
        puts "%d,%d" % [col, row]
        return
      end
    end
  end
end

part1
part2

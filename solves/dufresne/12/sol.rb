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

def get_perim map, start_row, start_col
  to_visit = []
  visited = Set.new
  perim = 0
  type = map[start_row][start_col]
  to_visit << [start_row, start_col]
  while not to_visit.empty?
    r, c = to_visit.shift
    next if visited.include?([r,c])
    visited << [r,c]
    # UP
    if r == 0
      perim += 1
    else
      if map[r-1][c] == type
        to_visit << [r - 1, c] unless visited.include?([r-1, c])
      else
        perim += 1
      end
    end

    # DOWN
    if r == map.size - 1
      perim += 1
    else
      if map[r+1][c] == type
        to_visit << [r + 1, c] unless visited.include?([r+1, c])
      else
        perim += 1
      end
    end

    # LEFT
    if c == 0
      perim += 1
    else
      if map[r][c - 1] == type
        to_visit << [r, c - 1] unless visited.include?([r, c-1])
      else
        perim += 1
      end
    end

    # RIGHT
    if c == map[0].size - 1
      perim += 1
    else
      if map[r][c + 1] == type
        to_visit << [r, c + 1] unless visited.include?([r, c+1])
      else
        perim += 1
      end
    end
  end
  [perim, visited]
end

def follow nrow, ncol, row, col, side, nodes
  if [:top, :bottom].include?(side)
    # go right
    r, c = row, col
    while c < (ncol - 1) and nodes.include?([r, c + 1, side])
      nodes.delete([r,c+1,side])
      c += 1
    end
    # go left
    r, c = row, col
    while c > 0 and nodes.include?([r, c - 1, side])
      nodes.delete([r,c-1,side])
      c -= 1
    end
  elsif [:left, :right].include?(side)
    # go down
    r, c = row, col
    while r < (nrow - 1) and nodes.include?([r + 1, c, side])
      nodes.delete([r + 1, c, side])
      r += 1
    end
    # go up
    r, c = row, col
    while r > 0 and nodes.include?([r - 1, c, side])
      nodes.delete([r - 1, c, side])
      r -= 1
    end
  else
    raise "Invalid side: #{side}"
  end
  nodes.delete([row, col, side])
end

def merge_perims map, xs
  used = Set.new
  perim = 0
  while not xs.empty?
    row, col, side = xs.shift
    follow(map.size, map[0].size, row, col, side, xs)
    perim += 1
  end
  perim
end

def get_perim2 map, start_row, start_col
  to_visit = []
  visited = Set.new
  #edges = Set.new
  edges = []
  perim = 0
  type = map[start_row][start_col]
  to_visit << [start_row, start_col]
  while not to_visit.empty?
    r, c = to_visit.shift
    next if visited.include?([r,c])
    visited << [r,c]
    # UP
    if r == 0
      perim += 1
      edges << [r,c,:top]
    else
      if map[r-1][c] == type
        to_visit << [r - 1, c] unless visited.include?([r-1, c])
      else
        edges << [r,c,:top]
        perim += 1
      end
    end

    # DOWN
    if r == map.size - 1
      perim += 1
      edges << [r,c,:bottom]
    else
      if map[r+1][c] == type
        to_visit << [r + 1, c] unless visited.include?([r+1, c])
      else
        perim += 1
        edges << [r,c,:bottom]
      end
    end

    # LEFT
    if c == 0
      perim += 1
      edges << [r,c,:left]
    else
      if map[r][c - 1] == type
        to_visit << [r, c - 1] unless visited.include?([r, c-1])
      else
        perim += 1
        edges << [r,c,:left]
      end
    end

    # RIGHT
    if c == map[0].size - 1
      perim += 1
      edges << [r,c,:right]
    else
      if map[r][c + 1] == type
        to_visit << [r, c + 1] unless visited.include?([r, c+1])
      else
        perim += 1
        edges << [r,c,:right]
      end
    end
  end
  perim = merge_perims(map, edges)
  [perim, visited]
end


def part1
  # lines = parse_as_lines INPUT
  # tokens = parse_as_tokens INPUT
  unique = Set.new
  map = []
  parse_as_custom(INPUT) { |line| 
    row = line.chomp.split(//)
    row.each { |r| unique << r }
    map << row
  }

  tot = 0
  marked = Set.new
  map.each_with_index do |row, ridx|
    row.each_with_index do |col, cidx|
      unless marked.include?([ridx, cidx])
        perim, visited = get_perim(map, ridx, cidx)
        marked += visited
        tot += perim * visited.size
      end
    end
  end
  puts tot
end


def part2
  # lines = parse_as_lines INPUT
  # tokens = parse_as_tokens INPUT
  unique = Set.new
  map = []
  parse_as_custom(INPUT) { |line| 
    row = line.chomp.split(//)
    row.each { |r| unique << r }
    map << row
  }

  tot = 0
  marked = Set.new
  map.each_with_index do |row, ridx|
    row.each_with_index do |col, cidx|
      unless marked.include?([ridx, cidx])
        perim, visited = get_perim2(map, ridx, cidx)
        marked += visited
        tot += perim * visited.size
      end
    end
  end
  puts tot
end


part1
part2

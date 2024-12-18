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

def score map, start, found
  r, c = start
  val = map[r][c]
  inc = val + 1
  if val == 9
   found << [r,c]
   return
  end 
  # Up
  if r > 0
    if map[r-1][c] == inc
      score(map, [r-1,c], found)
    end
  end
  # down
  if r < map.size - 1
    if map[r+1][c] == inc
      score(map, [r+1,c], found)
    end
  end
  # left
  if c > 0
    if map[r][c-1] == inc
      score(map, [r,c-1], found)
    end
  end
  #right
  if c < map[r].size - 1
    if map[r][c+1] == inc
      score(map, [r,c+1], found)
    end
  end
end

def score2 map, start, found
  tot = 0
  r, c = start
  val = map[r][c]
  inc = val + 1
  return 1 if val == 9
  # Up
  if r > 0
    if map[r-1][c] == inc
      tot += score2(map, [r-1,c], found)
    end
  end
  # down
  if r < map.size - 1
    if map[r+1][c] == inc
      tot += score2(map, [r+1,c], found)
    end
  end
  # left
  if c > 0
    if map[r][c-1] == inc
      tot += score2(map, [r,c-1], found)
    end
  end
  #right
  if c < map[r].size - 1
    if map[r][c+1] == inc
      tot += score2(map, [r,c+1], found)
    end
  end
  tot
end


def part1
  # lines = parse_as_lines INPUT
  # tokens = parse_as_tokens INPUT
  map = []
  parse_as_custom(INPUT) { |line| 
    map << line.chomp.split(//).collect { |i| i.to_i }
  }
  starts = []
  map.each_with_index do |row, ri|
    row.each_with_index do |col, ci|
      if col == 0
        starts << [ri, ci]
      end
    end
  end

  tot = 0
  starts.each do |start|
    found = Set.new
    score(map, start, found)
    tot += found.size
  end
  puts tot
end


def part2
  # lines = parse_as_lines INPUT
  # tokens = parse_as_tokens INPUT
  map = []
  parse_as_custom(INPUT) { |line| 
    map << line.chomp.split(//).collect { |i| i.to_i }
  }
  starts = []
  map.each_with_index do |row, ri|
    row.each_with_index do |col, ci|
      if col == 0
        starts << [ri, ci]
      end
    end
  end

  tot = 0
  starts.each do |start|
    found = Set.new
    tot += score2(map, start, found)
  end
  puts tot
end


part1
part2

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
  File.open(path, 'rb').each { |line| lines << line.chomp.split(//) }
  lines
end

# Returns the input as an array with each line the results of lambda.call(line)
def parse_as_custom path, &func
  data = []
  File.open(path, 'rb').each { |line| data << func.call(line) }
  data
end

def fill map, loc, dr, dc
  row, col = loc[0], loc[1]

  r = row + dr
  c = col + dc
  if r >= 0 and r < map.size and c >= 0 and c < map[0].size
    if map[r][c] == '.'
      return 1
    end
  end
  0
end

def fill2 map, loc, dr, dc, counted
  row, col = loc[0], loc[1]

  r = row + dr
  c = col + dc
  while r >= 0 and r < map.size and c >= 0 and c < map[0].size
    counted << [r,c]
    r += dr
    c += dc
  end
end

def part1
  # lines = parse_as_lines INPUT
  map = parse_as_tokens INPUT
  # custom = parse_as_custom(INPUT) { |line| line.size }
  poles = {} # [letter, locations}
  map.each_with_index do |row, ridx|
    row.each_with_index do |col, cidx|
      unless col == '.'
        poles[col] ||= []
        poles[col] << [ridx, cidx]
      end
    end
  end
  tot = 0
  poles.each do |pole, locs|
    locs.each do |loc1|
      locs.each do |loc2|
        dr = loc1[0] - loc2[0]
        dc = loc1[1] - loc2[1]
        tot += fill(map, loc1, dr, dc)
      end
    end
  end
  puts tot
end


def part2
  # lines = parse_as_lines INPUT
  map = parse_as_tokens INPUT
  # custom = parse_as_custom(INPUT) { |line| line.size }
  poles = {} # [letter, locations}
  map.each_with_index do |row, ridx|
    row.each_with_index do |col, cidx|
      unless col == '.'
        poles[col] ||= []
        poles[col] << [ridx, cidx]
      end
    end
  end
  counted = Set.new
  poles.each do |pole, locs|
    locs.each do |loc1|
      locs.each do |loc2|
        next if loc1 == loc2
        dr = loc1[0] - loc2[0]
        dc = loc1[1] - loc2[1]
        fill2(map, loc1, dr, dc, counted)
        counted << loc1
      end
    end
  end
  puts counted.size
end


part1
part2

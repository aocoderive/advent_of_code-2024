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

def advance2 sym, row, col, map, hist
  step = nil
  if sym == '<'
    return [nil, nil, nil] if col == 0
    step = [row, col - 1]
  elsif sym == '>'
    return [nil, nil, nil] if col == map[0].size - 1
    step = [row, col + 1]
  elsif sym == 'v'
    return [nil, nil, nil] if row == map.size - 1
    step = [row + 1, col]
  elsif sym == '^'
    return [nil, nil, nil] if row == 0
    step = [row - 1, col]
  end
  if map[step[0]][step[1]] == '#'
    sym = case sym
          when '<' then '^'
          when '^' then '>'
          when '>' then 'v'
          when 'v' then '<'
          end
    return advance2(sym, row, col, map, hist)
  end
  path = [[row, col], [step[0], step[1]]]
  if hist.include?(path)
    return [:loop, nil, nil]
  end
  hist << path
  [sym, step[0], step[1], hist]
end

def advance sym, row, col, map
  step = nil
  if sym == '<'
    return [nil, nil, nil] if col == 0
    step = [row, col - 1]
  elsif sym == '>'
    return [nil, nil, nil] if col == map[0].size - 1
    step = [row, col + 1]
  elsif sym == 'v'
    return [nil, nil, nil] if row == map.size - 1
    step = [row + 1, col]
  elsif sym == '^'
    return [nil, nil, nil] if row == 0
    step = [row - 1, col]
  end
  if map[step[0]][step[1]] == '#'
    sym = case sym
          when '<' then '^'
          when '^' then '>'
          when '>' then 'v'
          when 'v' then '<'
          end
    return advance(sym, row, col, map)
  end
  [sym, step[0], step[1]]
end

def dump map
  map.each do |row|
    puts "%s" % [row.join]
  end
end

def part1
  lines = parse_as_lines INPUT
  # tokens = parse_as_tokens INPUT
  # custom = parse_as_custom(INPUT) { |line| line.size }
  map = []
  lines.each do |line|
    map << line.split(//)
  end
  r, c = nil, nil
  sym = nil
  map.each_with_index do |row, y|
    next unless r.nil?
    row.each_with_index do |col, x|
      next unless r.nil?
      if ['<', '>', 'v', '^'].include?(col)
        r = y
        c = x
        sym = col
        map[y][x] = '.'
      end
    end
  end
  while sym
    # May need to check path for loops
    map[r][c] = 'X'
    sym, r, c = advance(sym, r, c, map)
  end

  tot = 0
  map.each do |row|
    row.each do |col|
      tot += 1 if col == 'X'
    end
  end
  puts tot

  #dump map
end

def copy_map map
  m = []
  map.each do |row|
    m << row.dup
  end
  m
end

def part2
  lines = parse_as_lines INPUT
  # tokens = parse_as_tokens INPUT
  # custom = parse_as_custom(INPUT) { |line| line.size }
  map = []
  lines.each do |line|
    map << line.split(//)
  end
  orig_r, orig_c = nil, nil
  orig_sym = nil
  map.each_with_index do |row, y|
    next unless orig_r.nil?
    row.each_with_index do |col, x|
      next unless orig_r.nil?
      if ['<', '>', 'v', '^'].include?(col)
        orig_r = y
        orig_c = x
        orig_sym = col
        map[y][x] = '.'
      end
    end
  end

  # Collect just the paths used
  orig_map = copy_map map
  sym = orig_sym
  r = orig_r
  c = orig_c
  while sym
    map[r][c] = 'X'
    sym, r, c = advance(sym, r, c, map)
  end
  path = []
  map.each_with_index do |row, ridx|
    row.each_with_index do |col, cidx|
      path << [ridx, cidx] if col == 'X'
    end
  end

  tot = 0
  path.each_with_index do |idxs, n|
    ridx, cidx = idxs
    next if [ridx, cidx] == [orig_r, orig_c]
    m = copy_map orig_map
    r = orig_r
    c = orig_c
    h = Set.new
    sym = orig_sym
    m[ridx][cidx] = '#'
    while sym
      sym, r, c = advance2(sym, r, c, m, h)
      if sym == :loop
        tot += 1
        sym = nil
      end
    end
  end
  puts tot
end

part1
part2

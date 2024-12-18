#!/usr/bin/env ruby

require 'set'

BOX = 'O'
LBOX = '['
RBOX = ']'
OPEN = '.'
WALL = '#'
ROBOT = '@'

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

def push_up map, robot
  row, col = robot
  dest = row - 1
  return robot if map[dest][col] == WALL
  while map[dest][col] == BOX
    dest -= 1
  end
  return robot if map[dest][col] == WALL
  while dest != row
    map[dest][col] = map[dest + 1][col]
    dest += 1
  end
  map[row][col] = OPEN
  [row - 1, col]
end

def push_down map, robot
  row, col = robot
  dest = row + 1
  return robot if map[dest][col] == WALL
  while map[dest][col] == BOX
    dest += 1
  end
  return robot if map[dest][col] == WALL
  while dest != row
    map[dest][col] = map[dest - 1][col]
    dest -= 1
  end
  map[row][col] = OPEN
  [row + 1, col]
end

def push_left map, robot
  row, col = robot
  dest = col - 1
  return robot if map[row][dest] == WALL
  while map[row][dest] == BOX
    dest -= 1
  end
  return robot if map[row][dest] == WALL
  while dest != col
    map[row][dest] = map[row][dest + 1]
    dest += 1
  end
  map[row][col] = OPEN
  [row, col - 1]
end

def push_right map, robot
  row, col = robot
  dest = col + 1
  return robot if map[row][dest] == WALL
  while map[row][dest] == BOX
    dest += 1
  end
  return robot if map[row][dest] == WALL
  while dest != col
    map[row][dest] = map[row][dest - 1]
    dest -= 1
  end
  map[row][col] = OPEN
  [row, col + 1]
end

def robot_move map, robot, move
  case move
  when '^'
    return push_up(map, robot)
  when 'v'
    return push_down(map, robot)
  when '<'
    return push_left(map, robot)
  when '>'
    return push_right(map, robot)
  end
  robot
end

def get_cols_up map, row, col, col_set
  check = row
  if [LBOX, RBOX].include?(map[check][col])
    col_set << [check, col]
    if map[check][col] == LBOX
      col_set << [check, col + 1]
      get_cols_up map, check - 1, col + 1, col_set
    else
      col_set << [check, col - 1]
      get_cols_up map, check - 1, col - 1, col_set
    end
    get_cols_up map, check - 1, col, col_set
  end
end

def get_cols_down map, row, col, col_set
  check = row
  if [LBOX, RBOX].include?(map[check][col])
    col_set << [check, col]
    if map[check][col] == LBOX
      col_set << [check, col + 1]
      get_cols_down map, check + 1, col + 1, col_set
    else
      col_set << [check, col - 1]
      get_cols_down map, check + 1, col - 1, col_set
    end
    get_cols_down map, check + 1, col, col_set
  end
end

def push_up2 map, robot
  row, col = robot
  dest = row - 1
  return robot if map[dest][col] == WALL
  if map[dest][col] == OPEN
    map[dest][col] = ROBOT
    map[row][col] = OPEN
    return [dest, col]
  end

  all_cols = Set.new
  all_cols << [dest, col]
  get_cols_up(map, dest, col, all_cols)
  if map[dest][col] == LBOX
    get_cols_up(map, dest, col + 1, all_cols)
  else
    get_cols_up(map, dest, col - 1, all_cols)
  end
  rows = {} # {row => moves}
  all_cols.each do |r,c|
    rows[r] ||= []
    rows[r] << [r,c]
    while [LBOX, RBOX].include?(map[r][c])
      r -= 1
    end
    # If *any* box is blocked, they are all blocked
    return robot if map[r][c] == WALL
  end
  rows.keys.sort.each do |crow|
    rows[crow].each do |r,c|
      map[r - 1][c] = map[r][c]
      map[r][c] = OPEN
    end
  end
  map[row][col] = OPEN
  map[row - 1][col] = ROBOT
  [row - 1, col]
end

def push_down2 map, robot
  row, col = robot
  dest = row + 1
  return robot if map[dest][col] == WALL
  if map[dest][col] == OPEN
    map[dest][col] = ROBOT
    map[row][col] = OPEN
    return [dest, col]
  end

  all_cols = Set.new
  all_cols << [dest, col]
  get_cols_down(map, dest, col, all_cols)
  if map[dest][col] == LBOX
    get_cols_down(map, dest, col + 1, all_cols)
  else
    get_cols_down(map, dest, col - 1, all_cols)
  end
  rows = {} # {row => moves}
  all_cols.each do |r,c|
    rows[r] ||= []
    rows[r] << [r,c]
    while [LBOX, RBOX].include?(map[r][c])
      r += 1
    end
    # If *any* box is blocked, they are all blocked
    return robot if map[r][c] == WALL
  end
  rows.keys.sort.reverse.each do |crow|
    rows[crow].each do |r,c|
      map[r + 1][c] = map[r][c]
      map[r][c] = OPEN
    end
  end
  map[row][col] = OPEN
  map[row + 1][col] = ROBOT
  [row + 1, col]
end

def push_left2 map, robot
  row, col = robot
  dest = col - 1
  return robot if map[row][dest] == WALL
  while [LBOX, RBOX].include?(map[row][dest])
    dest -= 1
  end
  return robot if map[row][dest] == WALL
  while dest != col
    map[row][dest] = map[row][dest + 1]
    dest += 1
  end
  map[row][col] = OPEN
  [row, col - 1]
end

def push_right2 map, robot
  row, col = robot
  dest = col + 1
  return robot if map[row][dest] == WALL
  while [LBOX, RBOX].include?(map[row][dest])
    dest += 1
  end
  return robot if map[row][dest] == WALL
  while dest != col
    map[row][dest] = map[row][dest - 1]
    dest -= 1
  end
  map[row][col] = OPEN
  [row, col + 1]
end

def robot_move2 map, robot, move
  case move
  when '^'
    return push_up2(map, robot)
  when 'v'
    return push_down2(map, robot)
  when '<'
    return push_left2(map, robot)
  when '>'
    return push_right2(map, robot)
  end
  robot
end

def part1
  # lines = parse_as_lines INPUT
  # tokens = parse_as_tokens INPUT
  map = []
  moves = []
  robot = nil
  parse_as_custom(INPUT) { |line|
    if line =~ /^#/
      rcol = line.index(ROBOT)
      unless rcol.nil?
        robot = [map.size, rcol]
      end
      map << line.chomp.split(//)
    elsif line =~ /^\s*$/
      next
    else
      moves += line.chomp.split(//)
    end
  }

  moves.each do |move|
    robot = robot_move map, robot, move
  end

  tot = 0
  map.each_with_index do |row, ridx|
    row.each_with_index do |col, cidx|
      if col == BOX
        tot += (100 * ridx) + cidx
      end
    end
  end
  puts tot
end


def part2
  # lines = parse_as_lines INPUT
  # tokens = parse_as_tokens INPUT
  map = []
  moves = []
  robot = nil
  parse_as_custom(INPUT) { |line|
    if line =~ /^#/
      xs = []
      line.chomp.split(//).each_with_index do |x, i|
        case x
        when WALL
          xs << WALL
          xs << WALL
        when BOX
          xs << LBOX
          xs << RBOX
        when OPEN
          xs << OPEN
          xs << OPEN
        when ROBOT
          xs << ROBOT
          xs << OPEN
          robot = [map.size, i * 2]
        end
      end
      map << xs
    elsif line =~ /^\s*$/
      next
    else
      moves += line.chomp.split(//)
    end
  }

  moves.each_with_index do |move, i|
    robot = robot_move2 map, robot, move
  end

  tot = 0
  map.each_with_index do |row, ridx|
    row.each_with_index do |col, cidx|
      if col == LBOX
        tot += (100 * ridx) + cidx
      end
    end
  end
  puts tot
end


part1
part2

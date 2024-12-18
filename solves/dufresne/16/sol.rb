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

def follow map, start
  row, col = start
  best = nil
  full_paths = Set.new
  queue = [[row, col, :east, 0, Set.new]]
  while not queue.empty?
    row, col, dir, cost, path = queue.shift

    next if best and cost > best
    next if full_paths.include?([row, col, dir])

    case dir
    when :east
      while map[row][col] != '#'
        if map[row][col] == 'E'
          best ||= cost
          best = [best, cost].min
          break
        end
        path << [row, col]
        full_paths << [row, col, dir]
        # Check N/S
        check = row - 1
        if map[check][col] != '#'
          unless path.include?([check, col])
            queue << [check, col, :north, cost + 1001, path.dup]
          end
        end
        check = row + 1
        if map[check][col] != '#'
          unless path.include?([check, col])
            queue << [check, col, :south, cost + 1001, path.dup]
          end
        end
        col += 1
        cost += 1 unless map[row][col] == '#'
      end
    when :west
      while map[row][col] != '#'
        if map[row][col] == 'E'
          best ||= cost
          best = [best, cost].min
          break
        end
        path << [row, col]
        full_paths << [row, col, dir]
        # Check N/S
        check = row - 1
        if map[check][col] != '#'
          unless path.include?([check, col])
            queue << [check, col, :north, cost + 1001, path.dup]
          end
        end
        check = row + 1
        if map[check][col] != '#'
          unless path.include?([check, col])
            queue << [check, col, :south, cost + 1001, path.dup]
          end
        end
        col -= 1
        cost += 1 unless map[row][col] == '#'
      end
    when :north
      while map[row][col] != '#'
        if map[row][col] == 'E'
          best ||= cost
          best = [best, cost].min
          break
        end
        path << [row, col]
        full_paths << [row, col, dir]
        # Check E/W
        check = col + 1
        if map[row][check] != '#'
          unless path.include?([row, check])
            queue << [row, check, :east, cost + 1001, path.dup]
          end
        end
        check = col - 1
        if map[row][check] != '#'
          unless path.include?([row, check])
            queue << [row, check, :west, cost + 1001, path.dup]
          end
        end
        row -= 1
        cost += 1 unless map[row][col] == '#'
      end
    when :south
      while map[row][col] != '#'
        if map[row][col] == 'E'
          best ||= cost
          best = [best, cost].min
          break
        end
        path << [row, col]
        full_paths << [row, col, dir]
        # Check E/W
        check = col + 1
        if map[row][check] != '#'
          unless path.include?([row, check])
            queue << [row, check, :east, cost + 1001, path.dup]
          end
        end
        check = col - 1
        if map[row][check] != '#'
          unless path.include?([row, check])
            queue << [row, check, :west, cost + 1001, path.dup]
          end
        end
        row += 1
        cost += 1 unless map[row][col] == '#'
      end
    end
  end
  best
end

def dump orig, x, row, col, dir, best
  map = []
  orig.each do |row|
    map << row.dup
  end
  x.each do |r, c, _|
    next if ['E', 'S'].include?(map[r][c])
    map[r][c] = 'O'
  end
  map[row][col] = case dir
                  when :east then '>'
                  when :west then '<'
                  when :north then '^'
                  when :south then 'v'
                  end
  print "   "
  map[0].each_with_index do |c, i|
    print "%d" % [i % 10]
  end
  puts
  map.each_with_index do |r, ri|
    if best and ri == 0
      puts "%2d #{r.join} (Best: #{best})" % [ri]
    else
      puts "%2d #{r.join}" % [ri]
    end
  end
  print "   "
  map[0].each_with_index do |c, i|
    print "%d" % [i % 10]
  end
  puts
end

def follow2 map, start
  total = {} # {[row, col, dir] => best score}
  scores = {} # {score => Set{path}}
  best = nil
  row, col = start
  queue = [[row, col, :east, 0, Set.new]]
  while not queue.empty?
    row, col, dir, cost, path = queue.shift
    key = [row, col, dir]

    next if map[row][col] == '#'

    # Prune if we've already found a closer path
    next if best and cost > best

    # Already visited this node, bail
    next if path.include?([row, col])

    #dump map, path, row, col, dir, best

    total[key] ||= cost
    next if cost > total[key]
    total[key] = cost

    # At this point..
    #  lowest cost for this cell/dir so far
    #  no loops in the path

    path << [row, col]

    # endpoint. Record score and continue knowing this may not be the best
    if map[row][col] == 'E'
      best ||= cost
      if cost <= best
        scores[cost] ||= Set.new
        scores[cost] += path.dup
      end
      best = [best, cost].min
      next
    end

    case dir
    when :east
      queue << [row, col + 1, :east, cost + 1, path.dup]
      queue << [row - 1, col, :north, cost + 1001, path.dup]
      queue << [row + 1, col, :south, cost + 1001, path.dup]
    when :west
      queue << [row, col - 1, :west, cost + 1, path.dup]
      queue << [row - 1, col, :north, cost + 1001, path.dup]
      queue << [row + 1, col, :south, cost + 1001, path.dup]
    when :north
      queue << [row - 1, col, :north, cost + 1, path.dup]
      queue << [row, col + 1, :east, cost + 1001, path.dup]
      queue << [row, col - 1, :west, cost + 1001, path.dup]
    when :south
      queue << [row + 1, col, :south, cost + 1, path.dup]
      queue << [row, col + 1, :east, cost + 1001, path.dup]
      queue << [row, col - 1, :west, cost + 1001, path.dup]
    end
  end
  dump map, scores[best], row, col, dir, best
  scores[best].size
end

def part1
  # lines = parse_as_lines INPUT
  # tokens = parse_as_tokens INPUT
  map = []
  start = nil
  parse_as_custom(INPUT) { |line| 
    xs = line.chomp.split(//)
    xs.each_with_index do |x, i|
      if x == 'S'
        start = [map.size, i]
      end
    end
    map << xs
  }

  tot = follow map, start
  puts tot
end


def part2
  # lines = parse_as_lines INPUT
  # tokens = parse_as_tokens INPUT
  map = []
  start = nil
  parse_as_custom(INPUT) { |line| 
    xs = line.chomp.split(//)
    xs.each_with_index do |x, i|
      if x == 'S'
        start = [map.size, i]
      end
    end
    map << xs
  }

  tot = follow2 map, start
  puts tot
end


part1
part2

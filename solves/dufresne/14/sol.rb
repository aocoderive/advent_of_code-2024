#!/usr/bin/env ruby

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

def quad_count bots, nrow, ncol

  left = []
  right = []
  bottom = []
  top = []
  mid = ncol / 2
  if ncol == 0
    left = (0...mid).to_a
    right = (mid...(ncol)).to_a
  else
    left = (0...mid).to_a
    right = ((mid + 1)...(ncol)).to_a
  end
  mid = nrow / 2
  if nrow % 2 == 0
    top = (0...mid).to_a
    bottom = (mid...(nrow)).to_a
  else
    top = (0...mid).to_a
    bottom = ((mid + 1)...(nrow)).to_a
  end
  q1, q2, q3, q4 = 0, 0, 0, 0
  bots.each do |bot|
    px, py = bot[0]
    if left.include?(px) 
      if top.include?(py)
        q1 += 1
      elsif bottom.include?(py)
        q3 +=1
      end
    elsif right.include?(px)
      if top.include?(py)
        q2 += 1
      elsif bottom.include?(py)
        q4 +=1
      end
    end
  end
  [q1, q2, q3, q4]
end

def draw bots, nrow, ncol
  map = []
  nrow.times {
    map << [0]*ncol
  }
  bots.each do |bot|
    px, py = bot[0]
    map[py][px] += 1
  end
  map.each do |row|
    puts row.collect { |i| i > 0 ? "%d" % i : " " }.join
  end
end

def part1
  # lines = parse_as_lines INPUT
  # tokens = parse_as_tokens INPUT
  ncol = 101
  nrow = 103
  bots = []
  parse_as_custom(INPUT) { |line| 
    #p=0,4 v=3,-3
    xs = line.chomp.split
    p = xs[0].split('=')[1].split(',').collect { |i| i.to_i }
    v = xs[1].split('=')[1].split(',').collect { |i| i.to_i }
    bots << [p, v]
  }
  bots.each do |bot|
    px, py = bot[0]
    x, y = bot[1]
    if x > 0
      bot[0][0] = (px + (100 * x)) % ncol
    elsif x < 0
      v = px + (100 * ncol)
      while v < (100 * x).abs
        v += 100 * ncol
      end
      bot[0][0] = (v + (100 * x)) % ncol
    end
    if y > 0
      bot[0][1] = (py + (100 * y)) % nrow
    elsif y < 0
      v = py + (100 * nrow)
      while v < (100 * y).abs
        v += 100 * nrow
      end
      bot[0][1] = (v + (100 * y)) % nrow
    end
  end
  q1, q2, q3, q4 = quad_count(bots, nrow, ncol)
  puts q1*q2*q3*q4
end

def moven bots, moves, nrow, ncol
  bots.each do |bot|
    px, py = bot[0]
    x, y = bot[1]
    if x > 0
      bot[0][0] = (px + (moves * x)) % ncol
    elsif x < 0
      v = px + (moves * ncol)
      while v < (moves * x).abs
        v += moves * ncol
      end
      bot[0][0] = (v + (moves * x)) % ncol
    end
    if y > 0
      bot[0][1] = (py + (moves * y)) % nrow
    elsif y < 0
      v = py + (moves * nrow)
      while v < (moves * y).abs
        v += moves * nrow
      end
      bot[0][1] = (v + (moves * y)) % nrow
    end
  end
end

def copy_bots bots
  copy = []
  bots.each do |bot|
    copy << [bot[0].dup, bot[1].dup]
  end
  copy
end

def part2
  # lines = parse_as_lines INPUT
  # tokens = parse_as_tokens INPUT
  ncol = 101
  nrow = 103
  bots = []
  parse_as_custom(INPUT) { |line| 
    #p=0,4 v=3,-3
    xs = line.chomp.split
    p = xs[0].split('=')[1].split(',').collect { |i| i.to_i }
    v = xs[1].split('=')[1].split(',').collect { |i| i.to_i }
    bots << [p, v]
  }

  #queue = [27, 73]
  queue = []
  103.times do |n|
    queue << 27 + (101 * n)
  end
  101.times do |n|
    queue << 73 + (103 * n)
  end

  # Sadly, this is brute force beyond figuring out the 
  # interval of the vertical and horizontal clustering 
  # :(
  while not queue.empty?
    moves = queue.shift
    copy = copy_bots bots
    moven copy, moves, nrow, ncol
    puts moves
    draw copy, nrow, ncol
    gets
  end
end


part1
part2

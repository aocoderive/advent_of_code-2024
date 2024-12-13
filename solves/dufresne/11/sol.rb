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

$cache = {} # {start => {n => count} }
$stones = []
$head = nil
$tail = nil

class Stone
  attr_accessor :left, :right, :value
  def initialize(num)
    @left = nil
    @right = nil
    @value = num
  end
  def to_s
    @value
  end
  def blink
    if @value == '0'
      @value = '1'
    elsif @value.size % 2 == 0
      mid = @value.size / 2
      l = @value[0...mid]
      r = @value[mid..-1]
      # Split
      # This stone becomes the 'left'
      # and we add one to the right linking it in
      @value = self.trim(l)
      rval = self.trim(r)
      ns = Stone.new(rval)
      if @right
        ns.right = @right
        ns.left = self
        @right.left = ns
        @right = ns
      else
        $tail = ns
        @right = ns
        ns.left = self
      end
    else
      @value = (@value.to_i * 2024).to_s
    end
  end
  def trim val
    return val unless val[0] == '0'
    i = 0
    while val[i] == '0'
      i += 1
    end
    s = val[i..-1]
    s = '0' if s.empty?
    s
  end
end

def blink
  s = $tail
  while s
    s.blink
    s = s.left
  end
end

def get_size s
  n = 0
  while s
    n += 1
    s = s.right
  end
  n
end

def trim val
  return val unless val[0] == '0'
  i = 0
  while val[i] == '0'
    i += 1
  end
  s = val[i..-1]
  s = '0' if s.empty?
  s
end

def blink2 stone
  return ['1', nil] if stone == '0'
  if stone.size % 2 == 0
    mid = stone.size / 2
    l = stone[0...mid]
    r = stone[mid..-1]
    return [l, trim(r)]
  end
  return [(stone.to_i * 2024).to_s, nil]
end

def get_splits stone, blinks
  return 0 if blinks < 1
  if $cache.include?(stone) 
    if $cache[stone].include?(blinks)
      return $cache[stone][blinks]
    end
  else
    $cache[stone] = {}
  end
  # Need to build from here
  a, b = blink2(stone)
  sub_tot = get_splits(a, blinks - 1)
  unless b.nil?
    sub_tot += 1 + get_splits(b, blinks - 1)
  end
  $cache[stone][blinks] = sub_tot
  sub_tot
end


def part1
  # lines = parse_as_lines INPUT
  # tokens = parse_as_tokens INPUT
  xs = []
  parse_as_custom(INPUT) { |line|
    xs = line.chomp.split
  }

  xs.each_with_index do |stone, idx|
    s = Stone.new(stone)
    if idx > 0
      s.left = $stones[-1]
      $stones[-1].right = s
    else
      $head = s
    end
    $stones << s
    $tail = s
  end

  25.times do 
    blink
  end
  puts get_size($head)
end


def part2
  # lines = parse_as_lines INPUT
  # tokens = parse_as_tokens INPUT
  xs = []
  parse_as_custom(INPUT) { |line|
    xs = line.chomp.split
  }
  blinks = 75
  tot = 0 
  xs.each do |stone|
    tot += (1 + get_splits(stone, blinks))
  end
  puts tot
end


part1
part2

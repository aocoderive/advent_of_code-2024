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


def part1
  # lines = parse_as_lines INPUT
  # tokens = parse_as_tokens INPUT
  l1 = []
  l2 = []
  custom = parse_as_custom(INPUT) { |line| 
    a, b = line.strip.split
    l1 << a.to_i
    l2 << b.to_i
  }
  l1 = l1.sort
  l2 = l2.sort
  tot = 0
  l1.zip(l2).each do |a, b|
    tot += (b - a).abs
  end
  puts tot
end


def part2
  # lines = parse_as_lines INPUT
  # tokens = parse_as_tokens INPUT
  l1 = []
  l2 = []
  custom = parse_as_custom(INPUT) { |line| 
    a, b = line.strip.split
    l1 << a.to_i
    l2 << b.to_i
  }
  tot = 0
  l1.each do |x|
    tot += (x * l2.count(x))
  end
  puts tot
end


part1
part2

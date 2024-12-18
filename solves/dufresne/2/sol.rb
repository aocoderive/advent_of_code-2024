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

def is_safe_1 xs
  prev = xs[0]
  dir = nil
  xs[1..-1].each do |x|
    if dir.nil?
      if x > prev
        dir = :up
      elsif x < prev
        dir = :down
      else
        return false
      end
    end
    return false if dir == :up and x <= prev
    return false if dir == :down and x >= prev
    return false if ((x - prev).abs > 3)
    prev = x
  end
  true
end

def is_safe_2 xs
  xs.size.times { |i|
    ys = xs.dup
    ys.delete_at(i)
    return true if is_safe_1(ys)
  }
  false
end

def part1
  # lines = parse_as_lines INPUT
  tokens = parse_as_tokens INPUT
  # custom = parse_as_custom(INPUT) { |line| line.size }
  tot = 0
  tokens.each do |line|
    xs = line.collect { |i| i.to_i }
    if is_safe_1(xs)
      tot += 1
    end
  end
  puts tot
end


def part2
  # lines = parse_as_lines INPUT
  tokens = parse_as_tokens INPUT
  # custom = parse_as_custom(INPUT) { |line| line.size }
  tot = 0
  tokens.each do |line|
    xs = line.collect { |i| i.to_i }
    if is_safe_1(xs) or is_safe_2(xs)
      tot += 1
    end
  end
  puts tot
end


part1
part2

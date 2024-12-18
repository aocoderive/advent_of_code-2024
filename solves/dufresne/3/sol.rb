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

def mul a, b
  a * b
end

def part1
  lines = parse_as_lines INPUT
  # tokens = parse_as_tokens INPUT
  # custom = parse_as_custom(INPUT) { |line| line.size }
  pattern = /mul\(\d{1,3},\d{1,3}\)/
  tot = 0
  lines.each do |line|
    line.scan(pattern).each { |m| tot += eval(m) }
  end
  puts tot
end


def part2
  lines = parse_as_lines INPUT
  # tokens = parse_as_tokens INPUT
  # custom = parse_as_custom(INPUT) { |line| line.size }
  full = ''
  lines.each do |line|
    full += line
  end

  # find stop, from there to next start insert invalid characters
  # loop until no stop found
  idx = 0
  quit = false
  pattern = /mul\(\d{1,3},\d{1,3}\)/
  stop = /don\'t\(\)/
  start = /do\(\)/
  while not quit
    loc = full[idx..-1] =~ stop
    if loc.nil?
      quit = true
    else
      loc2 = full[loc..-1] =~ start
      if loc2.nil?
        loc2 = full.size
        quit = true
      else
        loc2 += loc
      end
      full[loc...loc2] = '#'*(loc2 - loc)
    end
  end
  tot = 0
  full.scan(pattern).each { |m| tot += eval(m) }
  puts tot
end


part1
part2

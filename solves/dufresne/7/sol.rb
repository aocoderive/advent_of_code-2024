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

def build eq, args, results
  if args.empty?
    results << eval(eq)
  else
    neq = "(#{eq}+#{args[0]})"
    build(neq, args[1..-1], results)
    neq = "(#{eq}*#{args[0]})"
    build(neq, args[1..-1], results)
  end
end

def build2 eq, args, tgt
  if args.empty?
    return true if tgt == eval(eq)
  else
    # concat
    if eq[-1] == ')'
      x = eval(eq)
      neq = "(#{x}#{args[0]})"
    else
      neq = "#{eq}#{args[0]}"
    end
    return true if build2(neq, args[1..-1], tgt)
    neq = "(#{eq}+#{args[0]})"
    return true if build2(neq, args[1..-1], tgt)
    neq = "(#{eq}*#{args[0]})"
    return true if build2(neq, args[1..-1], tgt)
  end
  false
end

def part1
  # lines = parse_as_lines INPUT
  # tokens = parse_as_tokens INPUT
  eqs = [] # [val : args]
  parse_as_custom(INPUT) { |line| 
    xs = line.chomp.split
    val = xs[0][0..-2]
    args = xs[1..-1]
    eqs << [val, args]
  }
  tot = 0
  eqs.each do |tgt, args|
    results = []
    eq = args[0]
    build eq, args[1..-1], results
    if results.include?(tgt.to_i)
      tot += tgt.to_i
    end
  end
  puts tot
end


def part2
  # lines = parse_as_lines INPUT
  # tokens = parse_as_tokens INPUT
  eqs = [] # [val : args]
  parse_as_custom(INPUT) { |line| 
    xs = line.chomp.split
    val = xs[0][0..-2]
    args = xs[1..-1]
    eqs << [val, args]
  }
  tot = 0
  eqs.each do |tgt, args|
    results = []
    eq = args[0]
    if build2(eq, args[1..-1], tgt.to_i)
      tot += tgt.to_i
    end
  end
  puts tot
end


part1
part2

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

$ip = 0
$regs = {}
$output = []
$operand = {
  0 => lambda { 0 },
  1 => lambda { 1 },
  2 => lambda { 2 },
  3 => lambda { 3 },
  4 => lambda { $regs['A'] },
  5 => lambda { $regs['B'] },
  6 => lambda { $regs['C'] },
  7 => lambda { raise "Bad Operand" }
}
$opcode = {
  0 => lambda { |arg| 
    $regs['A'] = ($regs['A'] / (2**($operand[arg].call))).to_i
    $ip += 2 
  },
  1 => lambda { |arg| 
    $regs['B'] = $regs['B'] ^ arg
    $ip += 2 
  },
  2 => lambda { |arg| 
    $regs['B'] = $operand[arg].call % 8
    $ip += 2 
  },
  3 => lambda { |arg| 
    if $regs['A'] == 0
      $ip += 2 
    else 
      $ip = arg 
    end 
  },
  4 => lambda { |arg| 
    $regs['B'] = $regs['B'] ^ $regs['C']
    $ip += 2 
  },
  5 => lambda { |arg| 
    $output << $operand[arg].call % 8
    $ip += 2 
  },
  6 => lambda { |arg| 
    $regs['B'] = ($regs['A'] / (2**($operand[arg].call))).to_i
    $ip += 2 
  },
  7 => lambda { |arg| 
    $regs['C'] = ($regs['A'] / (2**($operand[arg].call))).to_i
    $ip += 2 
  }
}

def part1
  # lines = parse_as_lines INPUT
  # tokens = parse_as_tokens INPUT
  prog = []
  parse_as_custom(INPUT) { |line|
    if line =~ /^Register/
      _, reg, val = line.chomp.split
      $regs[reg.delete(':')] = val.to_i
    elsif line =~ /^Program/
      _, vals = line.chomp.split
      prog = vals.split(',').collect { |v| v.to_i }
    end
  }
  while $ip < (prog.size - 1)
    $opcode[prog[$ip]].call(prog[$ip + 1])
  end
  puts $output.collect { |x| "#{x}" }.join(',')
end

def run_prog prog, start
  $ip = 0
  $regs['A'] = start
  $output = []
  while $ip < (prog.size - 1)
    $opcode[prog[$ip]].call(prog[$ip + 1])
  end
  $output
end

def common_prefix p1, p2
  n = 0
  p1.zip(p2).each do |a,b|
    if a == b
      n += 1
    else
      return n
    end
  end
  n
end

def part2
  # lines = parse_as_lines INPUT
  # tokens = parse_as_tokens INPUT
  prog = []
  parse_as_custom(INPUT) { |line|
    if line =~ /^Register/
      _, reg, val = line.chomp.split
      $regs[reg.delete(':')] = val.to_i
    elsif line =~ /^Program/
      _, vals = line.chomp.split
      prog = vals.split(',').collect { |v| v.to_i }
    end
  }

  a = 0
  digit_buffer = 4
  computed = 0
  digits = 0
  shift = 8**digits
  while true
    start = a * shift + computed
    res = run_prog(prog, start)
    if res == prog
      puts start
      return
    end
    matches = common_prefix(prog, res)
    if matches >= digits + digit_buffer
      digits += 1
      mask = "0b%s" % ['1'*(digits * 3)]
      mask = mask.to_i(2)
      shift = 8**digits
      computed = start & mask
      a = 0
      #puts "0o%s %s" % [start.to_s(8), res]
      next
    end
    a += 1
  end
end

part1
part2

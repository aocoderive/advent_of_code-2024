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

def compute tgtx, tgty, buttons
  100.times do |a_press|
    100.times do |b_press|
      x = (buttons['a'][0] * a_press) + (buttons['b'][0] * b_press)
      y = (buttons['a'][1] * a_press) + (buttons['b'][1] * b_press)
      if tgtx == x and tgty == y
        return [a_press, b_press]
      end
    end
  end
  []
end

def compute2 tgtx, tgty, buttons
  ax, bx = buttons['a']
  ay, by = buttons['b']
  a, b, c, d = ax, ay, bx, by
  den = (a * d) - (b * c)
  top = (d * tgtx) + (-b * tgty)
  bot = (-c * tgtx) + (a * tgty)
  if top % den == 0 and bot % den == 0
    return [top / den, bot / den]
  end
  []
end

def part1
  # lines = parse_as_lines INPUT
  # tokens = parse_as_tokens INPUT
  tot = 0
  curr_game = { } # {a => [x, y], b => [x,y] }
  parse_as_custom(INPUT) { |line| 
    if line =~ /^Button/
      xs = line.chomp.split
      x = xs[2].split('+')[1].to_i
      y = xs[3].split('+')[1].to_i
      if xs[1][0] == 'A'
        curr_game['a'] = [x, y]
      else
        curr_game['b'] = [x, y]
      end
    elsif line =~ /Prize:/
      xs = line.chomp.split
      tgt_x = xs[1].split('=')[1].to_i
      tgt_y = xs[2].split('=')[1].to_i
      presses = compute(tgt_x, tgt_y, curr_game)
      unless presses.empty?
        tot += presses[0] * 3 + presses[1]
      end
      curr_game = {}
    end
  }
  puts tot
end


def part2
  # lines = parse_as_lines INPUT
  # tokens = parse_as_tokens INPUT
  tot = 0
  curr_game = { } # {a => [x, y], b => [x,y] }
  parse_as_custom(INPUT) { |line| 
    if line =~ /^Button/
      xs = line.chomp.split
      x = xs[2].split('+')[1].to_i
      y = xs[3].split('+')[1].to_i
      if xs[1][0] == 'A'
        curr_game['a'] = [x, y]
      else
        curr_game['b'] = [x, y]
      end
    elsif line =~ /Prize:/
      xs = line.chomp.split
      tgt_x = 10000000000000 + xs[1].split('=')[1].to_i
      tgt_y = 10000000000000 + xs[2].split('=')[1].to_i
      presses = compute2(tgt_x, tgt_y, curr_game)
      unless presses.empty?
        tot += presses[0] * 3 + presses[1]
      end
      curr_game = {}
    end
  }
  puts tot
end


part1
part2

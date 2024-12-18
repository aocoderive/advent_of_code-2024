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

def find_x m
  starts = []
  m.each_with_index do |row, ridx|
    row.each_with_index do |col, cidx|
      if col == 'X'
        starts << [ridx, cidx]
      end
    end
  end
  starts
end

def follow row, col, m
  tgt = ['X', 'M', 'A', 'S']
  # UP
  count = 0
  if row >= 3
    ti = 0
    r = row
    c = col
    while tgt[ti] == m[r][c]
      ti += 1
      r -= 1
      if ti == 4
        count += 1
        break
      end
    end

    # UL
    if col >= 3
      ti = 0
      r = row
      c = col
      while tgt[ti] == m[r][c]
        r -= 1
        c -= 1
        ti += 1
        if ti == 4
          count += 1
          break
        end
      end
    end

    # UR
    if col < (m[0].size - 3)
      ti = 0
      r = row
      c = col
      while tgt[ti] == m[r][c]
        r -= 1
        c += 1
        ti += 1
        if ti == 4
          count += 1
          break
        end
      end
    end
  end

  # DOWN
  if row < (m.size - 3)
    ti = 0
    r = row
    c = col
    while tgt[ti] == m[r][c]
      r += 1
      ti += 1
      if ti == 4
        count += 1
        break
      end
    end

    # DL
    if col >= 3
      ti = 0
      r = row
      c = col
      while tgt[ti] == m[r][c]
        c -= 1
        r += 1
        ti += 1
        if ti == 4
          count += 1
          break
        end
      end
    end

    # DR
    if col < (m[0].size - 3)
      ti = 0
      r = row
      c = col
      while tgt[ti] == m[r][c]
        c += 1
        r += 1
        ti += 1
        if ti == 4
          count += 1
          break
        end
      end
    end
  end

  # LEFT
  if col >= 3
    ti = 0
    r = row
    c = col
    while tgt[ti] == m[r][c]
      c -= 1
      ti += 1
      if ti == 4
        count += 1
        break
      end
    end
  end

  # RIGHT
  if col < (m[0].size - 3)
    ti = 0
    r = row
    c = col
    while tgt[ti] == m[r][c]
      c += 1
      ti += 1
      if ti == 4
        count += 1
        break
      end
    end
  end

  count
end

def find_a m
  starts = []
  m.each_with_index do |row, ridx|
    row.each_with_index do |col, cidx|
      if col == 'A'
        starts << [ridx, cidx]
      end
    end
  end
  starts
end

def follow2 row, col, m
  if col < 1 || col > (m[0].size - 2)
    return 0
  end
  if row < 1 || row > (m.size - 2)
    return 0
  end
  match = { 'M' => 'S', 'S' => 'M' }
  # DR
  return 0 unless match[m[row-1][col-1]] == m[row + 1][col + 1]
  # DL
  return 0 unless match[m[row-1][col+1]] == m[row + 1][col - 1]
  1
end


def part1
  # lines = parse_as_lines INPUT
  # tokens = parse_as_tokens INPUT
  matrix = []
  parse_as_custom(INPUT) { |line| 
    matrix << line.chomp.split(//)
  }
  idxs = find_x matrix
  tot = 0
  idxs.each do |row, col|
    tot += follow(row, col, matrix)
  end
  puts tot
end


def part2
  # lines = parse_as_lines INPUT
  # tokens = parse_as_tokens INPUT
  # custom = parse_as_custom(INPUT) { |line| line.size }
  matrix = []
  parse_as_custom(INPUT) { |line| 
    matrix << line.chomp.split(//)
  }
  idxs = find_a matrix
  tot = 0
  idxs.each do |row, col|
    tot += follow2(row, col, matrix)
  end
  puts tot
end


part1
part2

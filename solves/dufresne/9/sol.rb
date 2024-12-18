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

class Block
  attr_accessor :idx, :size, :id, :peer
  def initialize(idx, size, id)
    @idx, @size, @id = idx, size, id
    @peer = nil
  end

  def link(peer)
    @peer = peer
  end
end

def checksum disk
  tot = 0
  disk.each_with_index do |id, idx|
    next if id.nil?
    tot += (idx * id)
  end
  tot
end

def fix_blanks blanks
  new_blanks = []
  blanks.sort.each_with_index do |blank, idx|
    bidx, bsize = blank
    if idx == 0
      new_blanks << blank
    else
      if new_blanks[-1][0] + new_blanks[-1][1] == bidx
        new_blanks[-1] = [new_blanks[-1][0], new_blanks[-1][1] + bsize]
      else
        new_blanks << blank
      end
    end
  end
  new_blanks
end

def part1
  # lines = parse_as_lines INPUT
  # tokens = parse_as_tokens INPUT
  input = ''
  parse_as_custom(INPUT) { |line| 
    input = line.chomp.split(//).collect { |i| i.to_i }
  }
  blocks = []

  states = [:file, :free]
  state = 0

  nfiles = 0
  input.each do |n|
    if states[state % 2] == :file
      id = nfiles
      nfiles += 1
    else
      id = nil
    end
    n.times do 
      blocks << id
    end
    state += 1
  end

  idx = 0
  ridx = blocks.size - 1

  while idx < ridx
    if blocks[idx].nil?
      blocks[idx], blocks[ridx] = blocks[ridx], blocks[idx]
      idx += 1
      while blocks[ridx].nil?
        ridx -= 1
      end
    else
      idx += 1
    end
  end

  csum = checksum(blocks)
  puts csum
end


def part2
  # lines = parse_as_lines INPUT
  # tokens = parse_as_tokens INPUT
  input = ''
  parse_as_custom(INPUT) { |line| 
    input = line.chomp.split(//).collect { |i| i.to_i }
  }
  blocks = []

  states = [:file, :free]
  state = 0

  files = [] # [id, idx, size]
  blanks = [] # [idx, size]

  nfiles = 0
  input.each do |n|
    if states[state % 2] == :file
      id = nfiles
      files << [id, blocks.size, n]
      nfiles += 1
    else
      id = nil
      blanks << [blocks.size, n]
    end
    n.times do 
      blocks << id
    end
    state += 1
  end

  while not files.empty?
    fid, fidx, fsize = files.pop
    # find the best fit from the left
    found = false
    remain = 0
    tgt_idx = nil
    blanks.each_with_index do |blank, xidx|
      bidx, bsize = blank
      break if bidx > fidx
      if fsize <= bsize
        found = true
        remain = bsize - fsize
        tgt_idx = xidx
        fsize.times do |off|
          blocks[bidx + off], blocks[fidx + off] = blocks[fidx + off], blocks[bidx + off]
        end
      end
      break if found
    end
    if found
      if remain == 0
        # used the whole file, remove the blank
        blanks.delete_at(tgt_idx)
      else
        bidx, bsize = blanks[tgt_idx]
        blanks[tgt_idx] = [(bidx + bsize) - remain, remain]
      end
      blanks << [fidx, fsize]
      blanks = fix_blanks(blanks)
    end
  end

  csum = checksum(blocks)
  puts csum
end


part1
part2

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
  rules = {} # {first => []}
  pages = []
  parse_as_custom(INPUT) { |line|
    next if line =~ /^\s+$/
    if line =~ /\|/
      a, b = line.chomp.split('|')
      unless rules.include?(a.to_i)
        rules[a.to_i] = []
      end
      rules[a.to_i] << b.to_i
    else
      xs = line.chomp.split(',')
      pages << xs.collect { |x| x.to_i }
    end
  }
  tot = 0
  pages.each do |page|
    keep = true
    page.each_with_index do |elm, idx|
      next unless keep
      if not rules.include?(elm)
        if idx < page.size - 1
          keep = false
        end
      else
        rules[elm].each do |other|
          off = page.index(other)
          next if off.nil?
          if off < idx
            keep = false
          end
        end
      end
    end
    if keep
      tot += page[page.size / 2]
    end
  end
  puts tot
end

def get_bad_elm page, rules
  page.each_with_index do |elm, idx|
    if not rules.include?(elm)
      if idx < page.size - 1
        return elm
      end
    else
      rules[elm].each do |other|
        off = page.index(other)
        next if off.nil?
        if off < idx
          return elm
        end
      end
    end
  end
  nil
end

def reorder page, rules
  bad_elm = get_bad_elm page, rules
  while not bad_elm.nil?
    # find what makes this bad (appears before me)
    elm_idx = page.index bad_elm
    unless rules.include?(bad_elm)
      a, b = page[elm_idx], page[-1]
      page[-1] = a
      page[elm_idx] = b
    else
      rules[bad_elm].each do |other|
        off = page.index(other)
        next if off.nil?
        if off < elm_idx
          # move order, place bad elm just after this elm
          a, b = page[elm_idx], page[off]
          page[off] = a
          page[elm_idx] = b
        end
      end
    end
    bad_elm = get_bad_elm page, rules
  end
  page[page.size / 2]
end

def part2
  # lines = parse_as_lines INPUT
  # tokens = parse_as_tokens INPUT
  rules = {} # {first => []}
  pages = []
  parse_as_custom(INPUT) { |line|
    next if line =~ /^\s+$/
    if line =~ /\|/
      a, b = line.chomp.split('|')
      unless rules.include?(a.to_i)
        rules[a.to_i] = []
      end
      rules[a.to_i] << b.to_i
    else
      xs = line.chomp.split(',')
      pages << xs.collect { |x| x.to_i }
    end
  }
  tot = 0
  bad_pages = []
  pages.each do |page|
    keep = true
    page.each_with_index do |elm, idx|
      next unless keep
      if not rules.include?(elm)
        if idx < page.size - 1
          keep = false
        end
      else
        rules[elm].each do |other|
          off = page.index(other)
          next if off.nil?
          if off < idx
            keep = false
          end
        end
      end
    end
    unless keep
      bad_pages << page.dup
    end
  end
  tot = 0
  bad_pages.each do |bad|
    tot += reorder(bad, rules)
  end
  puts tot
end


part1
part2

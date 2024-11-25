#!/usr/bin/env ruby

PROGRAMMING_LANGUAGE = :ruby
#PROGRAMMING_LANGUAGE = :python

# This script and aoc.rb are expected reside in the same directory
$LOAD_PATH << File.realpath(File.dirname(__FILE__))

require 'aoc'

def usage
  prog = File.basename($0)
  $stderr.puts
  $stderr.puts "USAGE: #{prog} [year|day] [day]"
  $stderr.puts "-"*40
  $stderr.puts " Grabs an AOC challenge input based on parameters and"
  $stderr.puts "  opens a solution environment based on that."
  $stderr.puts
  $stderr.puts "Examples:"
  $stderr.puts "  Get the input for today's challenge"
  $stderr.puts "    #{prog}"
  $stderr.puts
  $stderr.puts "  Get the input for today's challenge in 2021"
  $stderr.puts "    #{prog} 2021"
  $stderr.puts
  $stderr.puts "  Get the input for day 12 of this year"
  $stderr.puts "    #{prog} 12"
  $stderr.puts
  $stderr.puts "  Get the input for day 19 of 2023"
  $stderr.puts "    #{prog} 2023 19"
  $stderr.puts
  exit 42
end

def err_out msg
  $stderr.puts 
  $stderr.puts msg
  $stderr.puts 
  exit 1
end

def ensure_valid year, day
  if year < 2020 or year > Time.now.year
    err_out "Year must be between 2020 and #{Time.now.year}"
  end
  if year == Time.now.year and Time.now.month < 12
    err_out "The AOC is not yet open this year."
  end
  max_day = 31
  if year == Time.now.year
    max_day = Time.now.day
  end
  if day < 1 or day > max_day
    err_out "Day must be between 1 and #{max_day} for #{year}"
  end
end

begin
  year = Integer(ARGV.shift || Time.now.year)
rescue
  usage
end
day = ARGV.shift

# if val < 2000 user provided a day
# if val > 2000 user provided a year
if day.nil?
  if year < 2000
    day = year
    year = Time.now.year
  else
    day = Time.now.day
  end
else
  begin
    day = Integer(day)
  rescue
    usage
  end
end

ensure_valid year, day

AOC.solve year, day, PROGRAMMING_LANGUAGE

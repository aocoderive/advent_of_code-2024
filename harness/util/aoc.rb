
module AOC

  SESSION_PATH = "${HOME}/.aoc"

  def AOC.get_session
    `cat #{SESSION_PATH}`.chomp
  end

  def AOC.get_input_dir year, day
    top = File.realpath(File.dirname(__FILE__)) + '/..'
    "%s/input/%d/%d" % [top, year, day]
  end

  def AOC.get_file_path year, day, fname
    AOC.get_input_dir(year, day) + "/#{fname}"
  end


  # Grab the specified challenge input from adventofcode.com
  def AOC.pull_input year, day

    tgt = AOC.get_input_dir year, day
    unless File.directory?(tgt)
      `mkdir -p #{tgt}`
    end

    # Check if path already exists. 
    # If it does we ask whether to overwrite it or use what is there
    overwrite = true
    path = AOC.get_file_path year, day, 'input'
    if File.exists?(path)
      $stderr.puts "File exists: #{path}"
      ans = '?'
      while not ['y', 'Y', 'n', 'N'].include?(ans)
        $stderr.print " Overwrite [y|N]: "
        ans = STDIN.getc
        if ans.chomp.empty?
          ans = 'n'
        end
      end
      if ['n', 'N'].include?(ans)
        overwrite = false
      end
    end

    if overwrite
      args = [year, day, AOC.get_session()]
      fmt = 'curl https://adventofcode.com/%d/day/%d/input --cookie "session=%s"'
      cmd = fmt % args
      data = `#{cmd}`.chomp
      f = File.open(path, 'wb')
      f.write(data)
      f.close
    end

  end


  # Verify the argument is one of the supported languages
  def AOC.lang_check lang
    unless [:ruby, :python].include? lang
      $stderr.puts 
      $stderr.puts "I only know how to solve in Ruby or Python."
      $stderr.puts
      exit 1
    end
  end


  # Create the initial solution template file in the requested location
  # Does *not* check for an existing file. This will blindly overwrite
  # any existing solution.
  def AOC.make_sol year, day, lang
    AOC.lang_check lang
    skel_dir = File.realpath(File.dirname(__FILE__)) + '/../skel'
    input = AOC.get_file_path year, day, 'input'
    sol = case lang
           when :ruby then AOC.get_file_path(year, day, 'sol.rb')
           when :python then AOC.get_file_path(year, day, 'sol.py')
           end
    skel = case lang
           when :ruby then skel_dir + "/ruby.skel"
           when :python then skel_dir + "/python.skel"
           end
    cmd = "sed -e 's|@@@INPUT@@@|#{input}|g' < #{skel} > #{sol}"
    `#{cmd}`
  end


  # Main entry point into the module. Should only need to call this from
  # the invoking script/code. This does the validation, pulls the challenge
  # input, creates an initial solution skeleton, and opens a set of terminals
  # to start.
  def AOC.solve year, day, lang = :ruby

    AOC.lang_check lang

    # Get the input if we do not already have it
    AOC.pull_input year, day

    # Create the skeleton solution file if it doesn't already exist
    sol = case lang
           when :ruby then AOC.get_file_path(year, day, 'sol.rb')
           when :python then AOC.get_file_path(year, day, 'sol.py')
           end
    unless File.exists?(sol)
      AOC.make_sol(year, day, lang)
    end

    editor = ENV['EDITOR']
    if editor.nil?
      editor = 'vim' # because, of course ;)
    end
    cmd = 'gnome-terminal -- %s %s' % [editor, sol]
    `#{cmd}`

    # Also bring up a shell with the interpreter open for the given language
    wd = AOC.get_input_dir year, day
    repl = case lang
           when :ruby then 'irb'
           when :python then 'python3'
           end
    cmd = "gnome-terminal --working-directory=#{wd} -- %s" % [repl]
    `#{cmd}`

    # Finally, bring up a terminal in that directory for running scripts
    cmd = "gnome-terminal --working-directory=#{wd}"
    `#{cmd}`

  end

end


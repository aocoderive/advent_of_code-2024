# AoC Harness
Harness for automating some common pieces for AOC.

Tested/developed on an Ubuntu-like Linux system.
Requires `ruby`, `gnome-terminal`, and an editor at a minimum

**NOTE:**
```
    Requires a valid session cookie for downloading the inputs with curl. 
    This should be placed in ${HOME}/.aoc
    Google 'how to get your session cookie for AOC' for more.
```


## Basic Usage

```bash
$ ruby util/solve.rb -h

USAGE: solve.rb [year|day] [day]
----------------------------------------
 Grabs an AOC challenge input based on parameters and
  opens a solution environment based on that.

Examples:
  Get the input for today's challenge
    solve.rb

  Get the input for today's challenge in 2021
    solve.rb 2021

  Get the input for day 12 of this year
    solve.rb 12

  Get the input for day 19 of 2023
    solve.rb 2023 19
```


## Setting the programming language

Change the `PROGRAMMING_LANGUAGE` variable at the top of `util/solve.rb`
Currently, only _Ruby_ and _Python_ are supported.
Just uncomment the one you want to use.

This will set to use _Python_:
```ruby
#PROGRAMMING_LANGUAGE = :ruby
PROGRAMMING_LANGUAGE = :python
```

This will set to use _Ruby_:
```ruby
PROGRAMMING_LANGUAGE = :ruby
#PROGRAMMING_LANGUAGE = :python
```


## Setting your editor

By default, the editor is `vim`.
You can change this by setting the **EDITOR** environment variable.
For example:

```bash
$ EDITOR=emacs ruby util/solve.rb 
```




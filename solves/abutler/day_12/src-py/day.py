import sys
import logging


################################################################################
def add_option(opt):
    g1 = optp.add_argument_group('Program Options')
    

################################################################################
def part1(args):
    logging.trace("")
    logging.info("part1, args=%s" % (args.params))

    with open(args.params[0]) as f:
        for line in f:
            l=line.strip()
            
    return

def part2(args):
    logging.trace("")
    logging.info("part2, args=%s" % (args.params))

    with open(args.params[0]) as f:
        for line in f:
            l=line.strip()

    return

def run(args):
    return

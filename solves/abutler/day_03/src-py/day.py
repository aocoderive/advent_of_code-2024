import sys
import logging

import re
from functools import reduce
from operator import mul,add


################################################################################
def add_option(opt):
    g1 = optp.add_argument_group('Program Options')
    

################################################################################
def part1(args):
    logging.trace("")
    logging.info("part1, args=%s" % (args.params))

    with open(args.params[0]) as f:
        sum = 0
        for line in f:
            l=line.strip()
            logging.debug("%s" % (l))
            
            m1 = re.findall(r"mul\(([0-9]{1,3}),([0-9]{1,3})\)",l)
            logging.debug(m1)
            
            m2 = map(lambda a: int(a[0]) * int(a[1]), m1)

            m3 = list(m2)
            print(m3)
            
            p = reduce(add, m3)

            sum += p
        print(sum)           

    return

def part2(args):
    logging.trace("")
    logging.info("part2, args=%s" % (args.params))

    input = ""
    sum = 0
    with open(args.params[0]) as f:
        for line in f:
            l=line.strip()
            input += l


    input = "do()"+input+"don't()"

    logging.debug(input)
    m1 = re.findall(r"do\(\)(.*?)don't\(\)",input)

    logging.debug(m1)

            
    for l in m1:
            
        m1 = re.findall(r"mul\(([0-9]{1,3}),([0-9]{1,3})\)",l)
        logging.debug(m1)
            
        m2 = map(lambda a: int(a[0]) * int(a[1]), m1)

        m3 = list(m2)
        logging.debug(m3)
            
        p = reduce(add, m3)

        sum += p
    print(sum)
            


def run(args):
    return

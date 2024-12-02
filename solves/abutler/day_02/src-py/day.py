import sys
import logging

import functools
import operator

################################################################################
def add_option(opt):
    g1 = optp.add_argument_group('Program Options')


def safe(l):
    safe = True
    sign = 0
    for i in l:
        j = abs(i)
        if (j == 0) or ( j > 3):
            safe = False
            break

        if sign == 0:
            if   (i > 0):
                sign = 1
            elif (i < 0):
                sign = -1
        else:
            if ( (i > 0 and sign == -1) or
                 (i < 0 and sign == 1) ):
                safe = False
                break
            
    return safe


################################################################################
def part1(args):
    logging.trace("")
    logging.info("part1, args=%s" % (args.params))

    with open(args.params[0]) as f:
        nsafe = 0
        for line in f:
            l=line.strip()

            r = list(map(int,l.split()))
            logging.debug("r=%s" % r)

            ds = []
            for i in range(len(r)-1):
                a = r[i]
                b = r[i+1]
                ds.append(b-a)

            logging.debug("ds=%s" % ds)
            if safe(ds):
                nsafe += 1                
                
            logging.debug("safe=%d" %(nsafe))
    print(nsafe)
    return

def part2(args):
    logging.trace("")
    logging.info("part2, args=%s" % (args.params))

    with open(args.params[0]) as f:
        nsafe = 0
        for line in f:
            l=line.strip()

            r = list(map(int,l.split()))
            logging.debug("r=%s" % r)

            ds = []
            for i in range(len(r)-1):
                a = r[i]
                b = r[i+1]
                ds.append(b-a)

            logging.debug("ds=%s" % ds)
            if safe(ds):
                nsafe += 1

            else:
                # TODO-2: only check if one point of inflection - "a single bad level"
                # TODO-2: only make mods at that single point,
                #            delete value and recalc diff around that value
                for i in range(len(r)):
                    r2 = r[:]
                    r2.pop(i)
                    ds = []
                    for j in range(len(r2)-1):
                        a = r2[j]
                        b = r2[j+1]
                        ds.append(b-a)
                    logging.debug(ds)
                    if safe(ds):
                        nsafe += 1
                        break
                    

            logging.debug("safe=%d" % nsafe)

    print(nsafe)
    return

def run(args):
    return

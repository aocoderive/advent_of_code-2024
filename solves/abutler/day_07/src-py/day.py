import sys
import logging


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
        for line in f:
            l=line.strip()

            if not l:
                continue
            s,n = l.split(":")
            sum = int(s)
            nums = n.split()
            nums = list(map(lambda a: int(a), nums))

            logging.debug("sum=%d, nums=%s" % (sum, nums) )

            ad = reduce(add,nums)
            mu = reduce(mul,nums)

            logging.debug("ad=%d, mu=%d" % (ad,mu) )
            
            if (ad <= sum) and (sum <= mu):
                logging.debug("process")


                
                total = 1

                for i in range(len(nums)):

                    
                    total = mul(total,nums[i])
                
                logging.debug(total)
                
                

                

            
            

            
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

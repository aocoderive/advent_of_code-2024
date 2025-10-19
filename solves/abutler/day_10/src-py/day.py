import sys
import logging

import numpy as np


################################################################################
def add_option(opt):
    g1 = optp.add_argument_group('Program Options')
    

################################################################################
def part1(args):
    logging.trace("")
    logging.info("part1, args=%s" % (args.params))


    A = []
    
    with open(args.params[0]) as f:
        for line in f:
            l=line.strip()
            #A.append(np.array([int(i) for i in l]))
            a = []
            for i in l:
                if i == '.':
                    a.append(-1)
                else:
                    a.append(int(i))
                    
            
            A.append(np.array(a))

    A = np.asarray(A)
    logging.debug("\n"+str(A))

    #starts = list(zip(*np.where(A == 0)))
    starts = np.argwhere(A == 0)
    logging.debug(starts)

    rows,cols = A.shape
    logging.debug(A.shape)


    seen = []
    def find_path(loc):
        ans = 0
        cur_val = A[tuple(loc)]

        logging.trace("")
        logging.debug("find_path: (%s),%d" % (loc,cur_val) )

        
        if cur_val == 9:
            seen.append(loc)
            return 1

        # find all neighbors
        x,y = tuple(loc)
        neighbs = [(i,j) for (i,j) in [ (x-1,y), (x+1,y), (x,y-1), (x,y+1) ]
                   if 0<=i<rows and 0<=j<cols]

        logging.debug("neighbs: %s" % (neighbs) )
        # check each n
        for n in neighbs:
            new_val = A[tuple(n)]
            logging.debug("(%s):%d" % (n,new_val) )

            if ( (n not in seen) and
                 (new_val == 1 + cur_val) ):
                ans += find_path(n)
            else:
                ans += 0
        logging.debug("ans = %d" % (ans) )
        return ans    

    result = 0
    for start in starts:
        seen = []
        logging.debug("start: %s" % start )
        result += find_path(start)


    print(result)

    
    return

def part2(args):
    logging.trace("")
    logging.info("part2, args=%s" % (args.params))


    A = []
    
    with open(args.params[0]) as f:
        for line in f:
            l=line.strip()
            #A.append(np.array([int(i) for i in l]))
            a = []
            for i in l:
                if i == '.':
                    a.append(-1)
                else:
                    a.append(int(i))
                    
            
            A.append(np.array(a))

    A = np.asarray(A)
    logging.debug("\n"+str(A))

    #starts = list(zip(*np.where(A == 0)))
    starts = np.argwhere(A == 0)
    logging.debug(starts)

    rows,cols = A.shape
    logging.debug(A.shape)


    seen = []
    def find_path(loc):
        ans = 0
        cur_val = A[tuple(loc)]

        logging.trace("")
        logging.debug("find_path: (%s),%d" % (loc,cur_val) )

        
        if cur_val == 9:
            #seen.append(loc)
            return 1

        # find all neighbors
        x,y = tuple(loc)
        neighbs = [(i,j) for (i,j) in [ (x-1,y), (x+1,y), (x,y-1), (x,y+1) ]
                   if 0<=i<rows and 0<=j<cols]

        logging.debug("neighbs: %s" % (neighbs) )
        # check each n
        for n in neighbs:
            new_val = A[tuple(n)]
            logging.debug("(%s):%d" % (n,new_val) )

            if ( (n not in seen) and
                 (new_val == 1 + cur_val) ):
                ans += find_path(n)
            else:
                ans += 0
        logging.debug("ans = %d" % (ans) )
        return ans    

    result = 0
    for start in starts:
        seen = []
        logging.debug("start: %s" % start )
        result += find_path(start)


    print(result)

    
    return

def run(args):
    return

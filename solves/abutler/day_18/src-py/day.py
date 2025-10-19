import sys
import logging

import numpy as np

################################################################################
def add_option(opt):
    g1 = optp.add_argument_group('Program Options')
    


size = 7    
rows = size
cols = size

start = (0,0)
end = (size-1,size-1)


def process_input1(args):
    A = np.full((size,size),'.')

    with open(args.params[0]) as f:
        for line in f:
            l=line.strip()

            y,x = map(int,l.split(','))
            logging.debug('set (%d,%d)' % (x,y) )
            A[x,y] = '#'
    return(A)
            
def print_board(A):
    #logging.debug("\n"+str(A))
    rows,cols = A.shape
    logging.debug(A.shape)
    logging.debug("\n" + '\n'+'\n'.join([''.join(row) for row in A]) )
    

def find_possible_next(A,cur):
    x,y = cur
    neighbs = [(i,j) for (i,j) in [ (x-1,y), (x+1,y), (x,y-1), (x,y+1) ]
               if 0<=i<rows and 0<=j<cols and A[i,j] != '#']
    logging.debug("neighbs: %s" % (neighbs) )
    return(neighbs)
    
def find_path(A,start,end):
    cur = start
    pos find_possible_next(A,cur)
    

def process_input(args):
    A = np.ones((size,size))
    
    with open(args.params[0]) as f:
        for line in f:
            l=line.strip()
            y,x = map(int,l.split(','))
            logging.debug('set (%d,%d)' % (x,y) )

            
    return(A)

    
################################################################################
def part1(args):
    logging.trace("")
    logging.info("part1, args=%s" % (args.params))
    #A = process_input(args)
    #find_path(A,start,end)

    A = process_input(args)
    
    
    
    print_board(A)
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

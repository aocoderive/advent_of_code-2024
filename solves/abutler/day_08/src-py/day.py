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
            A.append(np.array(list(l)))

    A = np.asarray(A)
    logging.debug("\n"+str(A))
    rows,cols = A.shape
    logging.debug(A.shape)


    # find set of ant
    ant = np.unique(A)
    ant = np.delete(ant, np.where('.'))
    logging.debug(ant)


    def cal_dist(a,b):
        new = []
        d = np.linalg.norm(a-b)
        logging.debug("%s - %s : %d" % (a,b,d) )

        d = a-b






        
        
        # first ele is y dim
        if a[0] < b[0]:
            # a above
            if a[1] < b[1]:
                # a above left of b
                logging.debug('ul: %s, %s - %s' % (a,b,d))
                n1 = tuple(a + d)
                n2 = tuple(b + abs(d))
            else:
                # a above right of b
                logging.debug('ur: %s, %s - %s' % (a,b,d))
                n1 = tuple(a + d)
                n2 = tuple(b - d)
        else:
            # a below
            if a[1] < b[1]:
                # a below left of b
                logging.debug('bl: %s, %s - %s' % (a,b,d))
                n1 = tuple(b - d)
                n2 = tuple(a - abs(d))
            else:
                # a below right of b
                logging.debug('br: %s, %s - %s' % (a,b,d))
                n1 = tuple(b - d)
                n2 = tuple(a - d)

        n_pos = [n1,n2]







        
        new = [(i,j) for (i,j) in n_pos
               if 0<=i<rows and 0<=j<cols]

        logging.debug("new = %s" % (new) )

        return(new)

        

    def all_pairs(lst):
        if len(lst) <= 1:
            return []
        pairs = [(lst[0], x) for x in lst[1:]]
        return pairs + all_pairs(lst[1:])


    new_locs = []
    a_locs_all = []
    for a in ant:
        logging.debug("ant=%s" % (a) )

        # ant locs
        x = np.where( A == a )
        a_locs = np.asarray(x).T
        logging.debug("a_locs = %s" % str(a_locs) )
        a_locs_all.append(a_locs)

    logging.debug("a_locs_all=%s" % (a_locs_all) )
    for a_loc in a_locs_all:
        logging.debug("a_loc=%s" % (a_loc) )
        for p in all_pairs(a_loc):
            logging.debug(p)
            new = cal_dist(p[0], p[1])

            for r in new:
                logging.debug(r)
                A[r] = '#'
                if r not in new_locs:
                    new_locs.append(r)

        A = np.asarray(A)
        logging.debug("\n"+str(A))

                    
    print(len(new_locs))

    return

def part2(args):
    logging.trace("")
    logging.info("part2, args=%s" % (args.params))


    A = []
    
    with open(args.params[0]) as f:
        for line in f:
            l=line.strip()        
            A.append(np.array(list(l)))

    A = np.asarray(A)
    logging.debug("\n"+str(A))
    rows,cols = A.shape
    logging.debug(A.shape)


    # find set of ant
    ant = np.unique(A)
    ant = np.delete(ant, np.where('.'))
    logging.debug(ant)


    def cal_dist(a,b):
        new = []
        d = np.linalg.norm(a-b)
        logging.debug("%s - %s : %d" % (a,b,d) )

        d = a-b



        new = []

        n_pos = []
        for i in range(0,100):

            m = [i]*2


            
            n = (0,0)
            # first ele is y dim
            if a[0] < b[0]:
                # a above
                if a[1] < b[1]:
                    # a above left of b
                    logging.debug('ul: %s, %s - %s' % (a,b,d))
                    n1 = tuple(a + d*m)
                    n2 = tuple(b + abs(d*m))
                else:
                    # a above right of b
                    logging.debug('ur: %s, %s - %s' % (a,b,d))
                    n1 = tuple(a + d*m)
                    n2 = tuple(b - d*m)
            else:
                # a below
                if a[1] < b[1]:
                    # a below left of b
                    logging.debug('bl: %s, %s - %s' % (a,b,d))
                    n1 = tuple(b - d*m)
                    n2 = tuple(a - abs(d*m))
                else:
                    # a below right of b
                    logging.debug('br: %s, %s - %s' % (a,b,d))
                    n1 = tuple(b - d*m)
                    n2 = tuple(a - d*m)
                    
            n_pos += [n1,n2]
            logging.debug("n_pos=%s" % (n_pos))








        
        new += [(i,j) for (i,j) in n_pos
               if 0<=i<rows and 0<=j<cols]

        logging.debug("new = %s" % (new) )

        return(new)

        

    def all_pairs(lst):
        if len(lst) <= 1:
            return []
        pairs = [(lst[0], x) for x in lst[1:]]
        return pairs + all_pairs(lst[1:])


    new_locs = []
    a_locs_all = []
    for a in ant:
        logging.debug("ant=%s" % (a) )

        # ant locs
        x = np.where( A == a )
        a_locs = np.asarray(x).T
        logging.debug("a_locs = %s" % str(a_locs) )
        a_locs_all.append(a_locs)

    logging.debug("a_locs_all=%s" % (a_locs_all) )
    for a_loc in a_locs_all:
        logging.debug("a_loc=%s" % (a_loc) )
        for p in all_pairs(a_loc):
            logging.debug(p)
            new = cal_dist(p[0], p[1])

            for r in new:
                logging.debug(r)
                A[r] = '#'
                if r not in new_locs:
                    new_locs.append(r)

        A = np.asarray(A)
        logging.debug("\n"+str(A))

                    
    print(len(new_locs))

    return

def run(args):
    return

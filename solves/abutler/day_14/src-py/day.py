import sys
import logging

import numpy as np
import re


################################################################################
def add_option(opt):
    g1 = optp.add_argument_group('Program Options')
    

################################################################################
def part1(args):
    logging.trace("")
    logging.info("part1, args=%s" % (args.params))

    rows = 103
    cols = 101

    A = np.full( (rows,cols), 0)


    logging.debug("cols=%d, rows=%d" %(cols,rows) )
    Robots = []
    
    with open(args.params[0]) as f:
        for line in f:
            l=line.strip()
            if not l:
                continue
            
            logging.debug(l)
            m = re.match("p=(-?\d+),(-?\d+) v=(-?\d+),(-?\d+)",l)

            if m:
                input=[ int(x) for x in m.group(1,2,3,4) ]
                logging.debug(input)

                robot = [input[:2],input[2:]]
                logging.debug(robot)
                Robots.append(robot)


    def move_robot(robot):
        logging.debug("move start:\t%s" % robot)
        
        robot[0][0] = robot[0][0] + robot[1][0]

        if   robot[0][0] >= cols:
            robot[0][0] = robot[0][0] - cols
        elif robot[0][0] < 0:
            robot[0][0] = cols + robot[0][0]
            
        robot[0][1] = robot[0][1] + robot[1][1]
        
        if   robot[0][1] >= rows:
            robot[0][1] = robot[0][1] - rows
        elif robot[0][1] < 0:
            robot[0][1] = rows + robot[0][1]
        
        logging.debug("move end:\t%s" % robot)


        
    seconds = 100
    while seconds > 0:
        for robot in Robots:
            move_robot(robot)

        seconds-=1

    logging.debug("Robots=%s" % ([r[0] for r in Robots]) )



    mid = [int(x) for x in [cols/2,rows/2]]
    logging.debug("%s" % mid)
    def count(Quads,robots):
        logging.debug("Quads=%s" % (Quads) )
        logging.debug("robot=%s" % (robot[0]) )
        if robot[0][0] < mid[0]:
            if robot[0][1] < mid[1]:
                Quads[0] += 1
            elif robot[0][1] > mid[1]:
                Quads[2] += 1
        elif robot[0][0] > mid[0]:
            if robot[0][1] < mid[1]:
                Quads[1] += 1
            elif robot[0][1] > mid[1]:
                Quads[3] += 1
        logging.debug("Quads=%s" % (Quads) )

    
    Quads=[0,0,0,0]           
    for robot in Robots:
        count(Quads,robot)

        
    logging.debug("Quads=%s" % Quads)
    print("%d" % (np.prod(Quads)) )
    
    return

def part2(args):
    logging.trace("")
    logging.info("part2, args=%s" % (args.params))

    rows = 103
    cols = 101

    logging.debug("cols=%d, rows=%d" %(cols,rows) )
    Robots = []
    
    with open(args.params[0]) as f:
        for line in f:
            l=line.strip()
            if not l:
                continue
            
            #logging.debug(l)
            m = re.match("p=(-?\d+),(-?\d+) v=(-?\d+),(-?\d+)",l)

            if m:
                input=[ int(x) for x in m.group(1,2,3,4) ]
                #logging.debug(input)

                robot = [input[:2],input[2:]]
                #logging.debug(robot)
                Robots.append(robot)


    def move_robot(robot):
        robot[0][0] = robot[0][0] + robot[1][0]

        if   robot[0][0] >= cols:
            robot[0][0] = robot[0][0] - cols
        elif robot[0][0] < 0:
            robot[0][0] = cols + robot[0][0]
            
        robot[0][1] = robot[0][1] + robot[1][1]
        
        if   robot[0][1] >= rows:
            robot[0][1] = robot[0][1] - rows
        elif robot[0][1] < 0:
            robot[0][1] = rows + robot[0][1]


    mid = [int(x) for x in [cols/2,rows/2]]
    #logging.debug("%s" % mid)

    def count(Quads,robots):
        if robot[0][0] < mid[0]:
            if robot[0][1] < mid[1]:
                # top left
                Quads[0] += 1
            elif robot[0][1] > mid[1]:
                # bottom left
                Quads[2] += 1
                
        elif robot[0][0] > mid[0]:
            if robot[0][1] < mid[1]:
                # top right
                Quads[1] += 1
            elif robot[0][1] > mid[1]:
                # bottom right
                Quads[3] += 1


    def entropy2(labels, base=None):
        """ Computes entropy of label distribution. """

        n_labels = len(labels)

        if n_labels <= 1:
            return 0

        value,counts = np.unique(labels, return_counts=True)
        probs = counts / n_labels
        n_classes = np.count_nonzero(probs)

        if n_classes <= 1:
            return 0
        
        ent = 0.
        
        # Compute entropy
        base = e if base is None else base
        for i in probs:
            ent -= i * log(i, base)
            
        return ent


    def print_robots(Robots):
        A = np.full( (rows,cols), ".")
    
        for robot in Robots:
            A[robot[0][1]][robot[0][0]] = '#'

        logging.debug("print")
        logging.debug("\n" + '\n'+'\n'.join([''.join(row) for row in A]) )

        return


    ##############################
    min_score = 100000000000
    max_seconds = 10000
    seconds = 1
    while seconds < max_seconds:
        for robot in Robots:
            move_robot(robot)

        Quads=[0,0,0,0]           
        for robot in Robots:
            count(Quads,robot)

        #logging.debug("Quads=%s" % (Quads))


        score = np.prod(Quads)

        logging.debug("sec=%d, score=%d" % (seconds,score) )
        if score < min_score:
            print("min sec=%d, score=%d" % (seconds,score) )
            print_robots(Robots)
            min_score = score
            
        seconds+=1

        
    return


def run(args):
    return

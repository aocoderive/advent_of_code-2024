import sys
import logging

import numpy as np

################################################################################
def add_option(opt):
    g1 = optp.add_argument_group('Program Options')
    




def find_path_out(A,start):
    rows,cols = A.shape

    E = np.full( (rows,cols), 0)
    e_rows,e_cols = E.shape

    
    Actions = []

    past_Actions = np.full( (rows,cols), 0)
    new_action = ( start, 1 )
    Actions.append(new_action)
    
    while Actions:
        cur_action = Actions.pop()
        (x,y),cur_move = cur_action
        E[x][y] = 1
        
        logging.debug("c: (%d,%d): %d" % (x,y,cur_move) )
        if cur_move == 1:
            if x-1 < 0:
                logging.debug("out")
                break
            if A[x-1][y] == "#":
                next_action = (x,y+1),2
            else:
                next_action = (x-1,y),1

        if cur_move == 2:
            if y+1 >= cols:
                logging.debug("out")
                break
            if A[x][y+1] == "#":
                next_action = (x+1,y),3
            else:
                next_action= (x,y+1),2

        if cur_move == 3:
            if x+1 >= rows:
                logging.debug("out")
                break
            if A[x+1][y] == "#":
                next_action = (x,y-1),4
            else:
                next_action = (x+1,y),3

        if cur_move == 4:
            if y-1 < 0:
                logging.debug("out")
                break

            if A[x][y-1] == "#":
                next_action = (x-1,y),1
            else:
                next_action = (x,y-1),4

        #(x,y),next_move = next_action
        #logging.debug("n: (%d,%d): %c" % (x,y,next_move) )


        #logging.debug(next_action)
        #logging.debug(past_Actions)
        
        if next_action[1] == past_Actions[x,y]:
            # loop
            logging.debug("loop")
            return(-1)
        
        past_Actions[x,y] = next_action[1]
                          
        Actions.append(next_action)
        
    logging.debug("\n" + str(E))

    return(E.sum())
          




################################################################################
def part1(args):
    logging.trace("")
    logging.info("part1, args=%s" % (args.params))

    A = []

    row = 0
    with open(args.params[0]) as f:
        for line in f:
            l=line.strip()
            a = np.array(list(l))
            A.append(a)            

            ai = np.where(a == '^')
            if ai[0]:
                start=[row,ai[0][0]]
            row += 1

    A = np.asarray(A)
    rows,cols = A.shape
    logging.debug("rows=%d, cols=%d\n" % (rows,cols)  + str(A) )
    logging.debug('start: %s: %s' % (start, A[start[0],start[1]]) )


    
    
    cover = find_path_out(A,start)

    print(cover)

    return

def part2a(args):
    logging.trace("")
    logging.info("part2, args=%s" % (args.params))

    A = []
    row = 0
    with open(args.params[0]) as f:
        for line in f:
            l=line.strip()
            a = np.array(list(l))
            A.append(a)            

            ai = np.where(a == '^')
            if ai[0]:
                start=(row,ai[0][0])
            row += 1

    A = np.asarray(A)
    rows,cols = A.shape
    logging.debug("rows=%d, cols=%d\n" % (rows,cols)  + str(A) )
    logging.debug('start: %s: %s' % (start, A[start[0],start[1]]) )

    E = A.copy()
    e_rows,e_cols = E.shape

    Actions = []
    new_action = ( start, "U" )
    Actions.append(new_action)

    # make a list of last 4 edges, if edge 4 intersects with edge 1 then can loop

    # every new edge
    #   if last (4th) (newest)  intersects with 1st (oldest),
    #     then where 4th intersects can loop
    
    # push last out of Q

    Edges = []
    global cur_edge_start
    cur_edge_start = start

    global loops
    loops = 0
    def add_edge(x,y):
        global cur_edge_start, loops
        logging.debug(Edges)

        cur_edge = [cur_edge_start,(x,y)]
        Edges.append(cur_edge)

        if len(Edges) == 4:
            last_edge = Edges.pop(0) # first
            # if last_edge interecets with cur_edge_start

            logging.debug("last=%s, cur=%s" % (last_edge, cur_edge) )

            last_edge_start = last_edge[0]
            cur_edge_end = cur_edge[-1]
            ls_x,ls_y = last_edge_start
            ce_x,ce_y = cur_edge_end
            logging.debug("last_start=(%s,%s), cur_end=(%s,%s)" % (ls_x,ls_y,ce_x,ce_y) )


            last_edge_end = last_edge[-1]
            cur_edge_start = cur_edge[0]
            le_x,le_y = last_edge_end
            cs_x,cs_y = cur_edge_start
            logging.debug("last=_end(%s,%s), cur_end=(%s,%s)" % (le_x,le_y,cs_x,cs_y) )

            
            if  ( (ls_x >= ce_x) and (ls_y >= ce_y) and
                  (cs_x >= le_x) and (cs_y >= le_y) ):
                loops += 1
                logging.debug("loopA %d" % (loops) )

#                E[ce_x,le_y-1] = 'O'
                logging.debug("\n" + '\n'+'\n'.join([''.join(row) for row in E]) )

            elif ((ls_x >= ce_x) and (ls_y <= ce_y) and
                  (cs_x >= le_x) and (cs_y <= le_y) ):
                loops += 1
                logging.debug("loopB %d" % (loops) )

#                E[le_x-1,ce_y] = 'O'
                logging.debug("\n" + '\n'+'\n'.join([''.join(row) for row in E]) )

            elif ((ls_x <= ce_x) and (ls_y <= ce_y) and
                  (cs_x <= le_x) and (cs_y <= le_y) ):
                loops += 1
                logging.debug("loopC %d" % (loops) )

#                E[cs_x,le_y+1] = 'O'
                logging.debug("\n" + '\n'+'\n'.join([''.join(row) for row in E]) )
                
            elif ((ls_x <= ce_x) and (ls_y >= ce_y) and
                  (cs_x <= le_x) and (cs_y >= le_y) ):
                loops += 1
                logging.debug("loopD %d" % (loops) )

#                E[ls_x+1,ce_y] = 'O'
                logging.debug("\n" + '\n'+'\n'.join([''.join(row) for row in E]) )

        cur_edge_start = (x,y)

        logging.debug(Edges)

        return


    
    while Actions:
        cur_action = Actions.pop()
        (x,y),cur_move = cur_action

        logging.debug("c: (%d,%d): '%c'  %c" % (x,y,E[x][y],cur_move) )

        if E[x][y] != '+':
            if   (cur_move == "U") or (cur_move == "D"):
                if E[x][y] == '-':
                    E[x][y] = '+'
                else:
                    E[x][y] = '|'

            elif (cur_move == "R") or (cur_move == "L"):
                if E[x][y] == '|':
                    E[x][y] = '+'
                else:
                    E[x][y] = '-'
            
        if cur_move == "U":
            if x-1 < 0:
                logging.debug("out")
                break
            if A[x-1][y] == "#":
                next_action = (x,y+1),"R"
                add_edge(x,y)
            else:
                next_action = (x-1,y),"U"

        elif cur_move == "R":
            if y+1 >= cols:
                logging.debug("out")
                break
            if A[x][y+1] == "#":
                next_action = (x+1,y),"D"
                add_edge(x,y)
            else:
                next_action = (x,y+1),"R"

        elif cur_move == "D":
            if x+1 >= rows:
                logging.debug("out")
                break
            if A[x+1][y] == "#":
                next_action = (x,y-1),"L"
                add_edge(x,y)
            else:
                next_action = (x+1,y),"D"

        elif cur_move == "L":
            if y-1 < 0:
                logging.debug("out")
                break
            if A[x][y-1] == "#":
                next_action = (x-1,y),"U"
                add_edge(x,y)
            else:
                next_action = (x,y-1),"L"


        #(x,y),next_move = next_action
        #logging.debug("n: (%d,%d): %c" % (x,y,next_move) )

        Actions.append(next_action)

    add_edge(x,y) # check last

    logging.debug("\n" + str(E))

    logging.debug("\n" + '\n'+'\n'.join([''.join(row) for row in E]) )

    print(loops)
          
    return


def part2(args):
    logging.trace("")
    logging.info("part2, args=%s" % (args.params))


    A = []

    row = 0
    with open(args.params[0]) as f:
        for line in f:
            l=line.strip()
            a = np.array(list(l))
            A.append(a)            

            ai = np.where(a == '^')
            if ai[0]:
                start=[row,ai[0][0]]
            row += 1

    A = np.asarray(A)
    rows,cols = A.shape
    logging.debug("rows=%d, cols=%d\n" % (rows,cols)  + str(A) )
    logging.debug('start: %s: %s' % (start, A[start[0],start[1]]) )


    count_loops = 0


    cover = find_path_out(A,start)

    #return

    
    for i in range(rows):
        for j in range(cols):
            print("%d,%d" % (i,j) )
            if A[i,j] == "#":
                continue
            logging.debug("check %d,%d" %(i,j) )
            A[i][j] = "#"
            
            cover = find_path_out(A,start)
            if cover == -1:
                count_loops += 1
                logging.debug(count_loops)

            A[i][j] = "."
            
    
    print(count_loops)

    
    return


def run(args):
    return

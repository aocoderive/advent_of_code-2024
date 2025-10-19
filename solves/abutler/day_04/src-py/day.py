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
            if l:
                A.append(np.array(list(l)))

    A = np.asarray(A)
    rows,cols = A.shape
    logging.debug2("start: (%d,%d)\n%s" % (rows,cols,A) )


    def char_match(a,b):
        if a == b:
            logging.debug("c=%c, w=%c: %s" % (a,b, True))
            return True
        else:
            logging.debug("c=%c, w=%c: %s" % (a,b, False))
            return False

    word = "XMAS"
    word_len = len(word)


    #up    = x-1
    def check_up(x,y):
        logging.debug("CU: x=%d, rows=%d, word_len=%s, rows-word=%d" %(x, rows, word_len, rows-word_len))
        return x >= (word_len-1)
    def move_up(x,y,i):
        return(x-i,y)

    #down  = x+1
    def check_down(x,y):
        logging.debug("CD: x=%d, rows=%d, word_len=%s, rows-word=%d" %(x, rows, word_len, rows-word_len))
        return x <= (rows - word_len)
    def move_down(x,y,i):
        return(x+i,y)

    #right = y+1
    def check_right(x,y):
        logging.debug("CR: y=%d, cols=%d, word_len=%s, cols-word=%d" %(y, cols, word_len, cols-word_len))
        return y <= (cols - word_len)
    def move_right(x,y,i):
        return(x,y+i)
    
    #left  = y-1
    def check_left(x,y):
        logging.debug("CL: y=%d, cols=%d, word_len=%s, cols-word=%d" %(y, cols, word_len, cols-word_len))
        return y >= (word_len-1)
    def move_left(x,y,i):
        return(x,y-i)
    
    def check_for_words(x,y):
        c = 0
        logging.debug("** x=%d, y=%d: %c" % (x,y,A[x,y]))
        if A[x+0][y+0] != word[0]:
            return c

        logging.debug("right")
        if check_right(x,y):
            for i in range(1,word_len):
                n,m = move_right(x,y,i)
                if not char_match(A[n][m],word[i]):
                    break
                if i == word_len-1:
                    c += 1
                    logging.debug("found %d, x=%d, y=%d" % (c,x,y) )

        logging.debug("left")
        if check_left(x,y):
            for i in range(1,word_len):
                n,m = move_left(x,y,i)
                if not char_match(A[n][m],word[i]):
                    break
                if i == word_len-1:
                    c += 1
                    logging.debug("found %d, x=%d, y=%d" % (c,x,y) )

        logging.debug("up")
        if check_up(x,y):
            for i in range(1,word_len):
                n,m = move_up(x,y,i)
                if not char_match(A[n][m],word[i]):
                    break
                if i == word_len-1:
                    c += 1
                    logging.debug("found %d, x=%d, y=%d" % (c,x,y) )

        logging.debug("down")
        if check_down(x,y):
            for i in range(1,word_len):
                n,m = move_down(x,y,i)
                if not char_match(A[n][m],word[i]):
                    break
                if i == word_len-1:
                    c += 1
                    logging.debug("found %d, x=%d, y=%d" % (c,x,y) )

        logging.debug("diag up-right")
        if check_up(x,y) and check_right(x,y):
            for i in range(1,word_len):
                n,m = move_up(x,y,i)
                n,m = move_right(n,m,i)
                if not char_match(A[n][m],word[i]):
                    break
                if i == word_len-1:
                    c += 1
                    logging.debug("found %d, x=%d, y=%d" % (c,x,y) )

        logging.debug("diag up-left")
        if check_up(x,y) and check_left(x,y):
            for i in range(1,word_len):
                n,m = move_up(x,y,i)
                n,m = move_left(n,m,i)                
                if not char_match(A[n][m],word[i]):
                    break
                if i == word_len-1:
                    c += 1
                    logging.debug("found %d, x=%d, y=%d" % (c,x,y) )

        logging.debug("diag down-left")
        if check_down(x,y) and check_left(x,y):
            for i in range(1,word_len):
                n,m = move_down(x,y,i)
                n,m = move_left(n,m,i)                
                if not char_match(A[n][m],word[i]):
                    break
                if i == word_len-1:
                    c += 1
                    logging.debug("found %d, x=%d, y=%d" % (c,x,y) )

        logging.debug("diag down-right")
        if check_down(x,y) and check_right(x,y):
            for i in range(1,word_len):
                n,m = move_down(x,y,i)
                n,m = move_right(n,m,i)                
                if not char_match(A[n][m],word[i]):
                    break
                if i == word_len-1:
                    c += 1
                    logging.debug("found %d, x=%d, y=%d" % (c,x,y) )

        return c


    #check all elem
    words = 0
    for x in range(rows):
        for y in range(cols):
            words += check_for_words(x,y)

    print(words)
    return

def part2(args):
    logging.trace("")
    logging.info("part1, args=%s" % (args.params))

    A = []
    with open(args.params[0]) as f:
        for line in f:
            l=line.strip()
            if l:
                A.append(np.array(list(l)))

    A = np.asarray(A)
    rows,cols = A.shape
    logging.debug2("start: (%d,%d)\n%s" % (rows,cols,A) )


    def char_match(a,b):
        if a == b:
            logging.debug("c=%c, w=%c: %s" % (a,b, True))
            return True
        else:
            logging.debug("c=%c, w=%c: %s" % (a,b, False))
            return False

    word = "XMAS"
    word_len = len(word)


    #up    = x-1
    def check_up(x,y):
        logging.debug("CU: x=%d, rows=%d, word_len=%s, rows-word=%d" %(x, rows, word_len, rows-word_len))
        return x >= (word_len-1)
    def move_up(x,y,i):
        return(x-i,y)

    #down  = x+1
    def check_down(x,y):
        logging.debug("CD: x=%d, rows=%d, word_len=%s, rows-word=%d" %(x, rows, word_len, rows-word_len))
        return x <= (rows - word_len)
    def move_down(x,y,i):
        return(x+i,y)

    #right = y+1
    def check_right(x,y):
        logging.debug("CR: y=%d, cols=%d, word_len=%s, cols-word=%d" %(y, cols, word_len, cols-word_len))
        return y <= (cols - word_len)
    def move_right(x,y,i):
        return(x,y+i)
    
    #left  = y-1
    def check_left(x,y):
        logging.debug("CL: y=%d, cols=%d, word_len=%s, cols-word=%d" %(y, cols, word_len, cols-word_len))
        return y >= (word_len-1)
    def move_left(x,y,i):
        return(x,y-i)


    def check_for_words(x,y):
        c = 0
        logging.debug("** x=%d, y=%d: %c" % (x,y,A[x,y]))
        if A[x+0][y+0] != 'A':
            return c

        logging.debug("c1: %d %d %d %d" % (x,y,rows-2, cols-2))
        if (x >= 1) and (x <= rows - 2) and (y >= 1) and (y <= cols - 2):
            logging.debug("c2: %d %d %d %d" % (x-1, y-1, x+1, y+1))
            logging.debug("c2: %c %c %c %c" % (A[x-1][y-1], A[x-1][y+1], A[x+1][y-1], A[x+1][y+1]))
            if ( (A[x-1][y-1] == 'M') and
                 (A[x-1][y+1] == 'S') and
                 (A[x+1][y-1] == 'M') and
                 (A[x+1][y+1] == 'S') ):
                 logging.debug("found %d, x=%d, y=%d" % (c,x,y) )
                 c += 1

            if ( (A[x-1][y-1] == 'M') and
                 (A[x-1][y+1] == 'M') and
                 (A[x+1][y-1] == 'S') and
                 (A[x+1][y+1] == 'S') ):
                 logging.debug("found %d, x=%d, y=%d" % (c,x,y) )
                 c += 1

            if ( (A[x-1][y-1] == 'S') and
                 (A[x-1][y+1] == 'S') and
                 (A[x+1][y-1] == 'M') and
                 (A[x+1][y+1] == 'M') ):
                 logging.debug("found %d, x=%d, y=%d" % (c,x,y) )
                 c += 1

            if ( (A[x-1][y-1] == 'S') and
                 (A[x-1][y+1] == 'M') and
                 (A[x+1][y-1] == 'S') and
                 (A[x+1][y+1] == 'M') ):
                 logging.debug("found %d, x=%d, y=%d" % (c,x,y) )
                 c += 1
                 
        return c


    #check all elem
    words = 0
    for x in range(rows):
        for y in range(cols):
            words += check_for_words(x,y)

    print(words)

    
def run(args):
    return

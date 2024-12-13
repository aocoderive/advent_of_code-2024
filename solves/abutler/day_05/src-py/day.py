import sys
import logging


################################################################################
def add_option(opt):
    g1 = optp.add_argument_group('Program Options')
    

################################################################################
def part1(args):
    logging.trace("")
    logging.info("part1, args=%s" % (args.params))

    rules = {}
    updates = []
    with open(args.params[0]) as f:
        order_rules=True
        for line in f:
            l=line.strip()
            if (order_rules):
                if not l:
                    order_rules = False
                    continue
                #collect all order rules
                a,b = map(int,l.split("|"))
                logging.debug("%d %d" % (a,b))

                b_list = rules.setdefault(b,[])
                b_list.append(a)
                
            else:
                # collect all pages nums
                a = list(map(int,l.split(",")))
                logging.debug("%s" % (a))
                updates.append(a)

    logging.debug("%s" % (rules))
    logging.debug("%s" % (updates))

    ok_cnt = 0
    ok_sum = 0
    for u in updates:
        for i in range(len(u)):

            cur = u[i]
            rest = u[i+1:]
            r = rules.get(u[i],"")


            logging.debug("u=%s cur=%s rest=%s, rules=%s" %(u, cur, rest, r))

            if (set(rest) & set(r)):
                # error
                logging.debug("nc: %s" % (u))
                break
            
        # ok
        if i == len(u)-1:
            ok_cnt += 1
            logging.debug(" c: %s" % (u))

            mid_pos = int( len(u) / 2.0 )

            logging.debug("mid_pos: %d, %d" % (mid_pos, u[mid_pos]))
            
            ok_sum += u[mid_pos]
            
            
                
    print(ok_sum)
                
    return

def part2(args):
    logging.trace("")
    logging.info("part1, args=%s" % (args.params))

    rules = {}
    updates = []
    with open(args.params[0]) as f:
        order_rules=True
        for line in f:
            l=line.strip()
            if (order_rules):
                if not l:
                    order_rules = False
                    continue
                #collect all order rules
                a,b = map(int,l.split("|"))
                logging.debug("%d %d" % (a,b))

                b_list = rules.setdefault(b,[])
                b_list.append(a)
                
            else:
                # collect all pages nums
                a = list(map(int,l.split(",")))
                logging.debug("%s" % (a))
                updates.append(a)

    logging.debug("%s" % (rules))
    logging.debug("%s" % (updates))

    ok_sum = 0


    def reorder(u):
        done = False
        c = False
        
        while not done:
            logging.debug("u1: %s" % (u))
            for i in range(len(u)):
                cur = u[i]
                rest = u[i+1:]
                r = rules.get(u[i],"")
                logging.debug("u=%s cur=%s rest=%s, rules=%s" %(u, cur, rest, r))

                intsec = set(rest) & set(r)
                logging.debug("intsec: %s" % (intsec))

                if intsec:
                    c = True
                    logging.debug("nc: %s" % (u))

                    j = u.index(list(intsec)[0])

                    logging.debug("%d %d %d %d" %(i, j, u[i], u[j]) )
                    # change i and j 
                    a = u[i]
                    b = u[j]

                    u[i] = b
                    u[j] = a

                    logging.debug("u2: %s" % (u))
                    break
            if i == len(u)-1:
                done = True

        return u,c

    for u in updates:
        u,c = reorder(u)

        if c:
            logging.debug(" c: %s" % (u))
            mid_pos = int( len(u) / 2.0 )
            logging.debug("mid_pos: %d, %d" % (mid_pos, u[mid_pos]))            
            ok_sum += u[mid_pos]
            
            
                
    print(ok_sum)
                
    return

def run(args):
    return

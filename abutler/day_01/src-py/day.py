import sys
import logging


################################################################################
def add_option(opt):
    g1 = optp.add_argument_group('Program Options')
    

################################################################################
def part1(args):
    logging.trace("")
    logging.info("part1, args=%s" % (args.params))

    result = 0

    list1 = []
    list2 = []
    with open(args.params[0]) as f:
        for line in f:
            l=line.strip()

            a,b = l.split()            
            logging.debug("a=%s" % a)
            logging.debug("b=%s" % b)
            list1.append(int(a))
            list2.append(int(b))

#        logging.debug("list1=%s", list1)
#        logging.debug("list2=%s", list2)

        list1.sort()
        list2.sort()

        logging.debug("list1=%s", list1)
        logging.debug("list2=%s", list2)

        sum = 0            
        for i in range(len(list1)):
            logging.debug("i=%d" % i)
            logging.debug("a=%d, b=%d" % (list1[i],list2[i]))

            d = abs(list2[i] - list1[i])
            
            logging.debug("diff %d" % d)
            sum += d
            logging.debug("sum=%d" % sum)
            
        print(sum)
    return

def part2(args):
    logging.trace("")
    logging.info("part2, args=%s" % (args.params))

    result = 0

    list1 = []
    list2 = []
    with open(args.params[0]) as f:
        for line in f:
            l=line.strip()

            a,b = l.split()            
            logging.debug("a=%s" % a)
            logging.debug("b=%s" % b)
            list1.append(int(a))
            list2.append(int(b))

        list1.sort()
        list2.sort()

        logging.debug("list1=%s", list1)
        logging.debug("list2=%s", list2)
        sum = 0            
        f = {}

        for i in range(len(list1)):
            logging.debug("i=%d" % list1[i])

            cnt = 0
            for j in range(len(list2)):
                if list2[j] == list1[i]:
                    cnt += 1

            sum += (list1[i] * cnt)
            
        print(sum)
    return

def run(args):
    return

"""
Advent of Code 2024 day 2

"""

f = open('day03example.txt', 'r')
#f = open('day03input.txt', 'r')
# make each line of input element in list
lines = f.readlines()
list_in = []
for line in lines:
    list_in.append(line)
print(list_in)

target = "mul(N01,N02)"
for i in range(len(target)):
    print(i, ": ", target[i])

twonums = []
products = []
for line in list_in:
    index = 0  #use this like a pointer in target
    i = 0      #this is another pointer for line
    while i < len(line):
        for char in line:
            print("target",target[index], " char", char," index", index," i",i, " line[i]", line[i])
            print(products)
#            print(" i+1", line[i+1], " i+2", line[i+2])
            if (index != 4) and (index != 8):
                if index == 8:
                    print("index is", index)
                if char == target[index]: #if it's a good char
                    if index == 11:
                        index = 0
                    index += 1
                    i += 1
                    continue
                else:
                    i += 1
                    index = 0
                    continue
            elif index == 4:
                if char.isnumeric(): #check if 2 or 3 digit number
                    if line[i+1].isnumeric():
                        if line[i+2].isnumeric(): #three digit number
                            if line[i+3] ==',':
                                index = 7
                                twonums.append( int(char+line[i+1]+line[i+2]) )
                                print(twonums)                                
                                i += 2
                            else:
                                index = 0
                                i += 1
                                continue
                        elif line[i+2] == ',':    #good two digit number
                            index = 7
                            print(char, line[i+1])
                            twonums.append( int(char+line[i+1]) )
                            print(twonums)
                            i += 1
                        else:
                            index = 0
                            i += 1
                            continue
                    elif line[i+1] == ',':        #good one digit number
                        index = 7
                        twonums.append( int(char) )
                        print(twonums)
                        i += 1
                        continue
                else:                    
                    index = 0
                    i += 1
                    continue
            elif index == 8:
                if char.isnumeric(): #check if 2 or 3 digit number
                    print("index 8 is numeric", char)
                    if line[i+1].isnumeric():
                        if line[i+2].isnumeric(): #three digit number
                            if line[i+3] ==')':
                                index = 11
                                twonums.append( int(char+line[i+1]+line[i+2]) )
                                products.append(twonums[0]*twonums[1])
                                twonums = []
                                print(twonums)
                                i += 2                                
                            else:
                                index = 0
                                i += 1
                                twonums = []
                                continue
                        elif line[i+2] == ')':    #good two digit number
                            index = 11
                            print(char, line[i+1])
                            twonums.append( int(char+line[i+1]) )
                            products.append(twonums[0]*twonums[1])
                            twonums = []
                            print(twonums)
                            i += 1
                        else:
                            twonums = []
                            index = 0
                            i += 1
                            continue
                    elif line[i+1] == ')':        #good one digit number
                        index = 11
                        twonums.append( int(char) )
                        products.append(twonums[0]*twonums[1])
                        twonums = []
                        print(twonums)
                        i += 1
                        continue
                    else:
                        twonums = []
                        index = 0
                        i += 1
                else:
                    print("char", char, "is not numeric")
                    i += 1
                    index = 0
                    twonums = []
                    continue
            




    

    
answer = 0
for i in products:
    answer += i
    
print()
print()
print(answer)

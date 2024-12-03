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
#for i in range(len(target)):
 #   print(i, ": ", target[i])

twonums = []
products = []
index = 0  #use this like a pointer in target
for line in list_in:
    for i, char in enumerate(line):
        print("target[index",target[index], " char", char," index", index," i",i, " line[i]", line[i]) 
        if index != (4 or 5 or 6 or 8 or 9 or 10):
            if char == target[index]: #if it's a good char
                index += 1
                continue
        elif index == 4:
            if char.isnumeric(): #check if 2 or 3 digit number
                if line[i+1].isnumeric():
                    if line[i+2].isnumeric(): #three digit number
                        if line[i+3] ==',':
                            index = 8
                            i = 8
                            twonums.append( int(char+line[i+1]+line[i+2]) )
                            print(twonums)
                        else:
                            index = 0
                            i = 8
                            continue
                    elif line[i+2] == ',':    #good two digit number
                        index = 8
                        i= 8
                        twonums.append( int(char+line[i+1]) )
                        print(twonums)
                    else:
                        index = 0
                        continue
                elif line[i+1] == ',':        #good one digit number
                    index = 8
                    i = 8
                    twonums.append( int(char) )
                    print(twonums)
                    continue
            else:
                index = 0
                continue
        elif index == 8:
            if char.isnumeric(): #check if 2 or 3 digit number
                if line[i+1].isnumeric():
                    if line[i+2].isnumeric(): #three digit number
                        if line[i+3] ==')':
                            index = 0
                            twonums.append( int(char+line[i+1]+line[i+2]) )
                            print(twonums)
                        else:
                            index = 0
                            continue
                    elif line[i+2] == ')':    #good two digit number
                        index = 0
                        twonums.append( int(char+line[i+1]) )
                        print(twonums)
                    else:
                        index = 0
                        continue
                elif line[i+1] == ')':        #good one digit number
                    index = 0
                    twonums.append( int(char) )
                    print(twonums)
                    continue
            else:
                index = 0
                continue
            




    

    
answer = 0
for i in products:
    answer += i
    
print()
print()
print(answer)

"""
Advent of Code 2024 day 2

"""
import copy

f = open('day02example.txt', 'r')
#f = open('day02input.txt', 'r')
# make each line of input element in list
lines = f.readlines()
list_in = []
for line in lines:
    list_in.append(line)
print(list_in)

levels = []
for ele in list_in:    #levels is list of lists
    level = [int(x) for x in ele.split()]
    levels.append(level)
print(levels)

answer = 0
for level in levels:
    flag = 0
    counter = 0
    badcheck = 0
    for j in range(len(level)-1):
        #generate a new list with all but i
        newlist = []
        newlist = copy.copy(level)
        newlist.remove(level[j])
       
        a = level[j] - level[j+1]
        if(a >= 1) and (a <= 3) and ( (flag == 0) or (flag == 2) ):
            flag = 2
            counter += 1
            print("descending")
        elif (a <= -1) and (a >= -3) and ( (flag == 0) or (flag == 1) ):
            flag = 1
            counter += 1
            print("ascending")
        else:
            for k in range(len(level)-1):
                #generate a new list with all but i
                newlist = []
                newlist = copy.copy(level)
                newlist.remove(level[k])

                print(newlist)
                flag2 = 0
                counter2 = 0
                for i in range(len(newlist)-1):
                    b = level[i] - level[i+1]
                    if(b >= 1) and (b <= 3) and ( (flag2 == 0) or (flag2 == 2) ):
                        flag2 = 2
                        counter2 += 1
                        print("small dec")
                    elif (b <= -1) and (b >= -3) and ( (flag2 == 0) or (flag2 == 1) ):
                        flag2 = 1
                        counter2 += 1
                        print("small ascending")
                    
                newacedec = (counter2 >= len(newlist)-1)
                if (newacedec):
                    answer += 1
                    print("ans", answer)
                    print()
                break

    acedec = counter == len(level)-1
    if (acedec):
        answer += 1
        print("ans", answer)
    print()
    



print()
print()
print(answer)

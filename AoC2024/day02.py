"""
Advent of Code 2024 day 2

"""

#f = open('day02example.txt', 'r')
f = open('day02input.txt', 'r')
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
    for i in range(len(level)-1):
        a = level[i] - level[i+1]
        if(a >= 1) and (a <= 3) and ( (flag == 0) or (flag == 2) ):
            flag = 2
            counter += 1
            print("descending")
        elif (a <= -1) and (a >= -3) and ( (flag == 0) or (flag == 1) ):
            flag = 1
            counter += 1
            print("ascending")
        else:
            print("same number")
            break

        
    acedec = counter == len(level)-1
    if (acedec):
        answer += 1
    print()


print()
print()
print(answer)

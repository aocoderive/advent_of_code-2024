# -*- coding: utf-8 -*-
"""
Advent of Code 2024 day 1

"""

f = open('01-input.txt', 'r')
# f = open('myinput01.txt', 'r')
# make each line of input element in list
lines = f.readlines()
list_in = []
for line in lines:
    list_in.append(line)

twonums = []
for ele in list_in:    #split into [num, num]
    twonums.append(ele.split())

print(twonums)

dist = []
rightlist = []
leftlist = []
for nums in twonums: 
    leftnum = nums[0]
    rightnum = nums[1]
    rightlist.append(int(rightnum))
    leftlist.append(int(leftnum))
    
rightlist.sort()
leftlist.sort()
print(rightlist)
print(leftlist)

answer = 0
for i in leftlist:
    sim = 0
    for k in rightlist:
        if i == k:
            sim += 1
    answer += i * sim


print()
print()
print(answer)
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

# coding=UTF-8
# 线性查找


def line_search(inputlist, item):
    count = 0
    index = 0
    for num in inputlist:
        count += 1
        if num == item:
            print ("run %d time"%(count))
            return index
        index += 1
    print ("run %d time" % (count))
    return None


my_list = [1, 2, 3, 5, 7, 9, 10]
print line_search(my_list, 9)
print line_search(my_list, -1)


# coding=UTF-8
# 折半查找


def binary_search(list, item):
    low = 0;
    high = len(list) -1
    count = 0

    while low <= high:
        count += 1
        mid = (low+high)/2
        guess = list[mid]
        if guess == item:
            print ("run %d time"%(count))
            return mid
        if guess > item:
            high = mid - 1
        else:
            low = mid + 1
    print ("run %d time"%(count))
    return None


my_list = [1, 2, 3, 5, 7, 9, 10]
print binary_search(my_list, 9)
print binary_search(my_list, -1)

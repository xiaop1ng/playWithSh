import datetime

input1 = ['xiaop1ng', 'colin2022']
input2 = ['ping@1234', 'colin@2022']
hours = [0,2,4,6,8,10,12,14,16,18,20,22]
h = datetime.datetime.now().hour
print(h)
idx = 0
try:
    idx = hours.index(h)%2
except Exception as e:
    idx = 0

print(input1[idx])
# -*- coding: utf-8 -*-
import math
import multiprocessing
from multiprocessing import Process

def cpuload(name):
    print('hello', name)
    while True:
        j = 1/1 + 1*1 - 1

if __name__ == '__main__':
    if multiprocessing.cpu_count() == 1:
        CPU_USED = 1
    else:
        CPU_USED=multiprocessing.cpu_count()/2
        
    print("Amount of processors on this server: ", multiprocessing.cpu_count())
    print("How many processors do you want to load? Plese input number from 1 to ", multiprocessing.cpu_count())
    for i in range(CPU_USED):
        name = "Process #%s" % (i+1)
        p = Process(target=cpuload, args=(name,))
        p.start()

#скрипт умеет нагружать работой все ядра процессора
#По умолчанию нагружается половина процессоров в системе
#Нужно научить при запуске скрипта выбирать процент загрузки процессора


#-*- coding:utf-8 -*-
import re,sys,os

# wrote: yangbing
# date: 20230708
# version: 1

for line in open("animals.csv","r"):
    if re.search("Scientific name",line):
        continue
    info = line.rstrip('\n').split(',')
    species = info[1].split('"')[1].replace(" ", "_").lower()
    filename = info[1].split('"')[1].replace(" ", "_")+"."+info[3].split('"')[1].replace(" ", "")+".pep.all.fa.gz"
    print("download {} pep.fa".format(species))
    try:
        os.system("wget -c -t 0 https://ftp.ensembl.org/pub/current_fasta/{}/pep/{}".format(species,filename))
    except:
        continue


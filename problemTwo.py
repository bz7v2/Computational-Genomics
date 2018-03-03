import csv
import pdb
import sys
import time
import numpy as np
import matplotlib.pyplot as plt
reader = csv.reader(open('genomeData.txt','r'), delimiter='\t')

csv.field_size_limit(sys.maxsize)
def gen_chunks(reader, chunksize=100):
	chunk = []
	for index, line in enumerate(reader):
		if (index % chunksize ==0 and index >0):
			yield chunk	
			del chunk[:]
		chunk.append(line)
	yield chunk


start_time = time.time()


NUM_ROWS=100

#
#key A,C,G,T,R,Y,S,W,K,M
#

#listOfRowsType = []
#for i in range(0, NUM_ROWS):
#	listOfRowsType.append([0,0,0,0,0,0,0,0,0,0])

listOfRowsType = np.zeros((NUM_ROWS,10), dtype=int)


def markAsSeen(row, snp_value):
	if snp_value=='A':
		listOfRowsType[row][0] = listOfRowsType[row][0]+1 
	if snp_value=='C':
		listOfRowsType[row][1] = listOfRowsType[row][1]+1 
	if snp_value=='G':
		listOfRowsType[row][2] = listOfRowsType[row][2]+1 
	if snp_value=='T':
		listOfRowsType[row][3] = listOfRowsType[row][3]+1 
	if snp_value=='R':
		listOfRowsType[row][4] = listOfRowsType[row][4]+1 
	if snp_value=='Y':
		listOfRowsType[row][5] = listOfRowsType[row][5]+1 
	if snp_value=='S':
		listOfRowsType[row][6] = listOfRowsType[row][6]+1 
	if snp_value=='W':
		listOfRowsType[row][7] = listOfRowsType[row][7]+1 
	if snp_value=='K':
		listOfRowsType[row][8] = listOfRowsType[row][8]+1 
	if snp_value=='M':
		listOfRowsType[row][9] = listOfRowsType[row][9]+1 






listOfRowsDist = []
for i in range(0, NUM_ROWS):
	listOfRowsDist.append(0)


lineNum =-2

for chunk in gen_chunks(reader, chunksize = 1):
	if(lineNum == NUM_ROWS-1):
		break
	lineNum = lineNum +1
	if lineNum == -1:
		continue;
	for col in range(1,955690):
		print(lineNum)
		print(chunk[0][col])
		if(chunk[0][col] != 'N'):
			#listOfRows[lineNum].append(chunk[0][col])
			listOfRowsDist[lineNum] = listOfRowsDist[lineNum]+1
			markAsSeen(lineNum, chunk[0][col])
			
	print(lineNum)

print(listOfRowsDist)

'''
lineNum =0
for chunk in gen_chunks(reader, chunksize = 1):
	lineNum = lineNum+1
	for inn, spot in enumerate(chunk):
		for row in range(1,955690):
			print(lineNum)
'''
elapse_time = time.time() - start_time
print("Evaluation took % .2f%", elapse_time)

xAxis = np.linspace(1,NUM_ROWS,NUM_ROWS)
print(xAxis)
print(listOfRowsDist)
plt.bar(xAxis, listOfRowsDist)
plt.xlabel("Line")
plt.ylabel("Number of Non N alleles")
plt.title("Number of Non N alleles per line")
plt.savefig("RowNum"+str(NUM_ROWS)+".png")
plt.show()


plt.stackplot(xAxis,
              listOfRowsType[:,0],
              listOfRowsType[:,1],
              listOfRowsType[:,2],
              listOfRowsType[:,3],
              listOfRowsType[:,4],
              listOfRowsType[:,5],
              listOfRowsType[:,6],
              listOfRowsType[:,7],
              listOfRowsType[:,8],
              listOfRowsType[:,9], colors=['g','k','y','m','c','r','g','k','y','m'])
plt.xlabel("line")
plt.ylabel("Breakdown of Non N alleles")
plt.title("Breakdown of Non N alleles by Line")
plt.plot([],[], color='g', label='A')
plt.plot([],[], color='k', label='C')
plt.plot([],[], color='y', label='G')
plt.plot([],[], color='m', label='T')
plt.plot([],[], color='c', label='R')
plt.plot([],[], color='r', label='Y')
plt.plot([],[], color='g', label='S')
plt.plot([],[], color='k', label='W')
plt.plot([],[], color='y', label='K')
plt.plot([],[], color='m', label='M')
plt.legend()

plt.savefig("RowTypes"+str(NUM_ROWS)+".png")
plt.show()

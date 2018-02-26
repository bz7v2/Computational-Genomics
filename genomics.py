import h5py
import numpy as np
from numba import vectorize
fh = h5py.File('g2f_2014_zeagbsv27.raw.h5')
print(list(fh['Genotypes'].keys()))

gene_lines = list(fh['Genotypes'].keys())


@vectorize(["int8(int8)"], target='cuda')
def hasIntersection(a):
	return a!=-1


loci = 1;
numLines   = len(fh['Genotypes'].keys())
print(numLines);

for loci in range(1, numLines):
	print(loci)
	for line in gene_lines:
		index2 = list(fh['Genotypes'][line])
		#print(index2)
		node = "/Genotypes/"+line+"/calls"
		#print(node);
		if node in fh.keys():
			#print(len(fh['Genotypes'][line]['calls'][1:1100]))
			print(type(fh['Genotypes'][line]['calls']))
			print(fh['Genotypes'][line]['calls'][:])
#			if fh['Genotypes'][line]['calls'][loci] != -1:
			#	print(type(fh['Genotypes'][line]['calls'][loci]))
				#print("intersect")
			

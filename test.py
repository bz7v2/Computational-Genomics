import numpy as np
from timeit import default_timer as timer
from numba import vectorize

@vectorize(["float32(float32, float32)"], target='cuda')
def vectorAdd(a,b):
	return a + b

def main():
	N = 320000
	
	A = np.ones(N, dtype=np.float32)
	B = np.ones(N, dtype=np.float32)
	C = np.zeros(N, dtype=np.float32)

	start = timer()
	C = vectorAdd(A,B)
	vectoradd_time = timer() - start
	print("c[:5]=" + str(C[:5]))
	print("Vector add took %f seconds" % vectoradd_time)

if __name__ == '__main__':
	main()

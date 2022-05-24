''' Implementation of a one-dimensional iterated map '''

import numpy as np, matplotlib.pyplot as plt, pandas as pd


def one_dimensional_map(n):
    ''' The One-dimensional Map '''
    x = []
    y = []
    for λ in np.arange(1.5, 4, 0.001):
        x0 = 0.5
        xn = [x0 * np.exp(λ*(1 - x0))]
        yn = [λ]
        for _ in range(0, n):
            xn.append(xn[_] * np.exp(λ*(1 - xn[_])))
            yn.append(λ)
        
        del xn[0:255], yn[0:255]

        x.append(xn)
        y.append(yn)
    
    return x, y

# Main driver
if __name__ == '__main__':
    n = pow(2, 9) # 2^9 = 512

    xn, yn = one_dimensional_map(n)

    plt.scatter(yn, xn, color='#cd0066', s=0.01)
    plt.xlim(1.5, 4)
    plt.xlabel('λ')
    plt.ylabel('xₙ')
    plt.title('One-Dimensional Iterated Map')
    plt.show()
''' Implementation of a generic Logistic Map '''

import numpy as np

def logistic(x0, n):
    ''' Logistic Map '''
    xn = [x0]
    for _ in range(0, n):
        xn.append(r * xn[_] * (1 - xn[_]))
    return xn

# Main driver
if __name__ == '__main__':
    z = 11.0/3.0 + 2.0/3.0 * (np.cbrt(100 + np.sqrt(9936)) + np.cbrt(100 - np.sqrt(9936)))
    r = 1.0 + np.sqrt(z)
    x0 = 0.2
    n = 1010
    print(logistic(x0, n)[1001:1011])
    
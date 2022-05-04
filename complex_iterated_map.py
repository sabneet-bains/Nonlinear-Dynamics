''' Implementation of a complex-valued iterated map '''

import numpy as np, matplotlib.pyplot as plt

def complex_iterated_map(x0, y0, n):
    ''' The Complex-valued Iterated Map '''
    xn = [np.pi + (1/2) * (x0 * np.cos(x0**2 + y0**2) - y0 * np.sin(x0**2 + y0**2))]
    yn = [(1/2) * (x0 * np.sin(x0**2 + y0**2) + y0 * np.cos(x0**2 + y0**2))]
    for _ in range(0, n):
        xn.append(np.pi + (1/2) * (xn[_] * np.cos(xn[_]**2 + yn[_]**2) - yn[_] * np.sin(xn[_]**2 + yn[_]**2)))
        yn.append((1/2) * (xn[_] * np.sin(xn[_]**2 + yn[_]**2) + yn[_] * np.cos(xn[_]**2 + yn[_]**2)))
    return xn, yn


# Main driver
if __name__ == '__main__':
    x0 = 2.46954962375565
    y0 = -1.51067616887886
    n = pow(2, 15)

    xn, yn = complex_iterated_map(x0, y0, n)

    plt.scatter(xn, yn, color='#cd0066', s=0.05)
    plt.xlabel('Re(z)')
    plt.ylabel('Im(z)')
    plt.title('Complex-Valued Iterated Map')
    plt.axis('equal')
    plt.show()

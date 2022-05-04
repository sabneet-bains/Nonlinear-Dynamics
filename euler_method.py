''' Implementation of the classic euler method for
    solving ordinary differential equations '''

import numpy as np

def f(t, x):
    ''' dx/dt or ẋ = f(x,t) '''
    return (3/10) * (1/np.cos(x/6))

def euler(t0, x0, t, Δt):
    ''' Euler method '''
    tn = t0
    xn = x0

    while tn < t:
        xn = xn + Δt * f(tn, xn)
        tn = tn + Δt

    return xn

# Main driver
if __name__ == '__main__':
    t0 = 0
    x0 = 0
    t = 10
    Δt = 1/100000
    print ('x(' + (str)(t) + ') ≈', euler(t0, x0, t, Δt))

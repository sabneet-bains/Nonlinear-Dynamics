''' Implementation of the classic fourth order Runge-Kutta
    method for solving ordinary differential equations '''

import numpy as np

def f(t, x):
    ''' dx/dt or ẋ = f(x,t) '''
    return (3/10) * (1/np.cos(x/6))

def RK4(t0, x0, t, Δt):
    ''' Runge-Kutta 4th order method '''
    tn = t0
    xn = x0
    n = (int)((t - tn)/Δt)

    for _ in range(1, n + 1):
        k1 = f(tn, xn)
        k2 = f(tn + 0.5 * Δt, xn + 0.5 * Δt * k1)
        k3 = f(tn + 0.5 * Δt, xn + 0.5 * Δt * k2)
        k4 = f(tn + Δt, xn + Δt * k3)

        xn = xn + (1/6) * Δt * (k1 + 2 * k2 + 2 * k3 + k4)
        tn = tn + Δt

    return xn

# Main driver
if __name__ == '__main__':
    t0 = 0
    x0 = 0
    t = 10
    Δt = 1/100000
    print ('x(' + (str)(t) + ') ≈', RK4(t0, x0, t, Δt))

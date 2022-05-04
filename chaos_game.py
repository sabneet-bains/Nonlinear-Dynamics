''' Implementation of the Chaos Game; an iterated map
    in two-dimensional space '''

import random, numpy as np, matplotlib.pyplot as plt

def chaos_game(a, P_list, n):
    ''' The Chaos Game '''
    x0 = random.SystemRandom().uniform(-999, 999)
    y0 = random.SystemRandom().uniform(-999, 999)
    Pj = random.SystemRandom().choice((P_list))

    xn = [a * x0 + Pj[0]]
    yn = [a * y0 + Pj[1]]

    for _ in range(0, n):
        Pj = random.SystemRandom().choice((P_list))
        xn.append(a * xn[_] + Pj[0])
        yn.append(a * yn[_] + Pj[1])

    del xn[0:100], yn[0:100]

    return xn, yn

# Main driver
if __name__ == '__main__':
    a = 41/108
    # P_list = [(-2, np.sqrt(3)), (2, np.sqrt(3)), (0, -2)]
    P_list = [(951,309),(588,-809),(-588,-809),(-951,309),(0,1000)]
    n = pow(2, 18)

    xn, yn = chaos_game(a, P_list, n)

    plt.scatter(xn, yn, color='#cd0066', s=0.05)
    plt.xlabel('xₙ')
    plt.ylabel('yₙ')
    plt.title('The Chaos Game: 2-D Iterated Map')
    plt.axis('equal')
    plt.show()

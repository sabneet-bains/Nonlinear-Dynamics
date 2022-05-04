''' Implementation of a generic Tent Map '''

def tent(x0, n):
    ''' Tent Map '''
    xn = [x0]
    for _ in range(0, n):
        if 0 <= xn[_] <= 1/2:
            xn.append(2 * xn[_])
        elif 1/2 < xn[_] <= 1:
            xn.append(2 - (2 * xn[_]))
    return xn

# Main driver
if __name__ == '__main__':
    x0 = 2/5
    n = 1005
    print(tent(x0, n)[1001:1006])

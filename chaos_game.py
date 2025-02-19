"""
Implementation of the Chaos Game; a 2-D iterated map.
This code simulates a contraction mapping where the next point is given by:
   xₙ₊₁ = a * xₙ + Pj_x
   yₙ₊₁ = a * yₙ + Pj_y
where Pj is chosen randomly from a list of fixed points in the plane.
The first 100 iterations are discarded to remove transient dynamics.

Author: Sabneet Bains
License: MIT License
"""

import random
import numpy as np
import matplotlib.pyplot as plt
import logging
from typing import List, Tuple

# Setup basic logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s [%(levelname)s] %(message)s")

def chaos_game(a: float, P_list: List[Tuple[float, float]], n: int) -> Tuple[List[float], List[float]]:
    """
    Run the Chaos Game iterated map in 2D.

    Parameters:
        a (float): Contraction factor (typically between 0 and 1).
        P_list (List[Tuple[float, float]]): List of fixed points (Pj_x, Pj_y) in the plane.
        n (int): Number of iterations (non-negative integer).

    Returns:
        Tuple[List[float], List[float]]: Lists of x- and y-coordinates of the iterated points
                                          after removing the first 100 transient iterations.
    """
    # Validate inputs
    if not isinstance(a, (float, int)):
        logging.error("Contraction factor a must be a number.")
        raise ValueError("a must be a number.")
    if a <= 0 or a >= 1:
        logging.warning("Contraction factor a is expected to be between 0 and 1 for typical chaos game behavior.")
    if not isinstance(P_list, list) or not all(isinstance(pt, tuple) and len(pt) == 2 for pt in P_list):
        logging.error("P_list must be a list of 2-element tuples.")
        raise ValueError("P_list must be a list of 2-element tuples.")
    if not isinstance(n, int) or n < 0:
        logging.error("Number of iterations n must be a non-negative integer.")
        raise ValueError("n must be a non-negative integer.")

    # Use system-based RNG for better randomness
    rng = random.SystemRandom()

    try:
        x0 = rng.uniform(-999, 999)
        y0 = rng.uniform(-999, 999)
        Pj = rng.choice(P_list)
    except Exception as e:
        logging.error("Error during random initialization: %s", e)
        raise

    # Initialize iterates
    xn: List[float] = [a * x0 + Pj[0]]
    yn: List[float] = [a * y0 + Pj[1]]

    for i in range(n):
        try:
            Pj = rng.choice(P_list)
        except Exception as e:
            logging.error("Error selecting random point at iteration %d: %s", i, e)
            raise
        xn.append(a * xn[i] + Pj[0])
        yn.append(a * yn[i] + Pj[1])

    # Remove the first 100 iterations to eliminate transients
    if len(xn) <= 100 or len(yn) <= 100:
        logging.warning("Not enough iterations to remove transients; returning full data.")
        return xn, yn
    return xn[100:], yn[100:]

def main() -> None:
    # Contraction factor and parameters
    a = 41 / 108
    P_list = [(951, 309), (588, -809), (-588, -809), (-951, 309), (0, 1000)]
    n = 2 ** 18

    logging.info("Starting Chaos Game simulation with a = %f, n = %d", a, n)
    try:
        xn, yn = chaos_game(a, P_list, n)
    except Exception as e:
        logging.error("Simulation failed: %s", e)
        return

    logging.info("Simulation completed, now plotting results.")
    plt.figure(figsize=(8, 8))
    plt.scatter(xn, yn, color='#cd0066', s=0.05)
    plt.xlabel('xₙ')
    plt.ylabel('yₙ')
    plt.title('The Chaos Game: 2-D Iterated Map')
    plt.axis('equal')
    plt.show()

if __name__ == '__main__':
    main()

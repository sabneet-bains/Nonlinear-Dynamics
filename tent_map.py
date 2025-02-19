"""
Implementation of a generic Tent Map.

The Tent Map is a simple one-dimensional chaotic map defined by:
    xₙ₊₁ = 2 * xₙ         if 0 <= xₙ <= 0.5
    xₙ₊₁ = 2 - 2 * xₙ     if 0.5 < xₙ <= 1

This script computes the iterates of the Tent Map for a given initial condition and
number of iterations. The main driver prints a subset of iterates after discarding
the initial transients.

Author: Sabneet Bains
License: MIT License
"""

import logging
from typing import List

# Configure logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s [%(levelname)s] %(message)s")

def tent(x0: float, n: int) -> List[float]:
    """
    Compute the iterates of the Tent Map.

    Parameters:
        x0 (float): The initial condition (should be in the interval [0, 1]).
        n (int): The number of iterations to perform.

    Returns:
        List[float]: A list containing the iterates of the Tent Map.
    """
    # Validate initial condition
    if not (0 <= x0 <= 1):
        logging.error("Initial condition x0=%f is out of bounds. It should be within [0,1].", x0)
        raise ValueError("x0 must be between 0 and 1.")
    if n < 0:
        logging.error("Number of iterations n=%d is negative.", n)
        raise ValueError("n must be a non-negative integer.")

    # Initialize list with the initial condition
    xn: List[float] = [x0]
    
    # Iterate the Tent Map n times
    for i in range(n):
        current = xn[i]
        if 0 <= current <= 0.5:
            next_val = 2 * current
        elif 0.5 < current <= 1:
            next_val = 2 - 2 * current
        else:
            logging.error("Encountered value %f out of bounds at iteration %d.", current, i)
            raise ValueError("Tent map iterates should remain within [0,1].")
        xn.append(next_val)
    
    return xn

def main() -> None:
    """
    Main driver function to run the Tent Map simulation and print selected iterates.
    """
    try:
        x0 = 2 / 5  # Initial condition
        n = 1005    # Number of iterations
        
        logging.info("Running Tent Map simulation with x0 = %f and n = %d", x0, n)
        iterates = tent(x0, n)
        
        # Print iterates from index 1001 to 1005
        selected_iterates = iterates[1001:1006]
        print("Tent Map iterates from index 1001 to 1005:", selected_iterates)
    except Exception as e:
        logging.error("An error occurred: %s", e)

if __name__ == '__main__':
    main()


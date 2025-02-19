"""
Implementation of a generic Logistic Map.

The logistic map is defined by the recurrence:
    x(n+1) = r * x(n) * (1 - x(n))
This script calculates the iterates of the logistic map for a given initial
condition, number of iterations, and logistic parameter r. The parameter r is
computed using a given formula involving cube roots and square roots.

Author: Sabneet Bains
License: MIT License
"""

import numpy as np
import logging
from typing import List

# Configure basic logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s [%(levelname)s] %(message)s")

def logistic(x0: float, n: int, r: float) -> List[float]:
    """
    Compute the iterates of the logistic map.
    
    The logistic map is given by:
        x(n+1) = r * x(n) * (1 - x(n))
    
    Parameters:
        x0 (float): The initial condition (typically in the interval [0, 1]).
        n (int): The number of iterations to perform.
        r (float): The logistic map parameter.
        
    Returns:
        List[float]: A list of iterates starting with x0 and containing n+1 values.
    """
    # Warn if x0 is outside the typical range for the logistic map
    if not (0 <= x0 <= 1):
        logging.warning("Initial condition x0 = %f is outside the typical range [0, 1].", x0)
    # Validate that number of iterations is non-negative
    if n < 0:
        raise ValueError("Number of iterations n must be a non-negative integer.")
    
    # Initialize list with the initial condition
    xn: List[float] = [x0]
    
    # Iterate the logistic map n times
    for i in range(n):
        # Calculate the next iterate and append it to the list
        xn.append(r * xn[i] * (1 - xn[i]))
    
    return xn

def main() -> None:
    """
    Main driver function for the Logistic Map simulation.
    
    This function computes the logistic map iterates for a given initial condition
    and parameter r, then prints the iterates from index 1001 to 1010.
    """
    try:
        # Calculate parameter r using the given formula
        # This involves computing a parameter z first and then r.
        z = 11.0 / 3.0 + 2.0 / 3.0 * (np.cbrt(100 + np.sqrt(9936)) + np.cbrt(100 - np.sqrt(9936)))
        r = 1.0 + np.sqrt(z)
        logging.info("Calculated r = %f", r)
        
        # Set the initial condition and number of iterations
        x0 = 0.2
        n = 1010  # Total number of iterations
        
        logging.info("Running logistic map with x0 = %f and n = %d", x0, n)
        # Compute the iterates using the logistic map function
        result = logistic(x0, n, r)
        
        # Print iterates from index 1001 to 1010 (i.e., 10 values after transient)
        iterates_to_print = result[1001:1011]
        print("x(1010) iterates (indices 1001 to 1010):", iterates_to_print)
        
    except Exception as e:
        logging.error("An error occurred: %s", e)

if __name__ == '__main__':
    main()

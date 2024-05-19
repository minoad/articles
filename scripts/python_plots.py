import numpy as np
import matplotlib.pyplot as plt

# Define the range of input sizes (n)
n_values = np.linspace(1, 6, 100)

# Define the corresponding execution times for each complexity class
constant_time = np.ones_like(n_values)
logarithmic_time = np.log(n_values)
sublinear_time = np.sqrt(n_values)
linearithmic_time = n_values * np.log(n_values)
linear_time = n_values
polynomial_time = n_values ** 2
quadratic_time = n_values ** 2
cubic_time = n_values ** 3
exponential_time = 2 ** n_values
#factorial_time = np.math.factorial(n_values)

# Plot the lines
plt.figure(figsize=(10, 8))

# First graph
plt.subplot(2, 1, 1)

plt.plot(n_values, constant_time, label='Constant Time: $O(1)$', color='blue')
plt.plot(n_values, logarithmic_time, label='Logarithmic Time: $O(\log n)$', color='orange')
plt.plot(n_values, sublinear_time, label='Sublinear Time: $O(\sqrt{n})$', color='green')
plt.plot(n_values, linearithmic_time, label='Linearithmic Time: $O(n \log n)$', color='red')

# Add labels and title for the first graph
plt.xlabel('Input Size ($n$)', fontsize=12)
plt.ylabel('Execution Time', fontsize=12)
plt.title('Complexity Classes (First Graph)', fontsize=14)
plt.legend(fontsize=10)
plt.grid(True)

# Second graph
plt.subplot(2, 1, 2)

plt.plot(n_values, linear_time, label='Linear Time: $O(n)$', color='purple')
plt.plot(n_values, polynomial_time, label='Polynomial Time: $O(n^2)$', color='brown')
plt.plot(n_values, quadratic_time, label='Quadratic Time: $O(n^2)$', color='pink')
plt.plot(n_values, cubic_time, label='Cubic Time: $O(n^3)$', color='gray')
plt.plot(n_values, exponential_time, label='Exponential Time: $O(2^n)$', color='cyan')

# Add labels and title for the second graph
plt.xlabel('Input Size ($n$)', fontsize=12)
plt.ylabel('Execution Time', fontsize=12)
plt.title('Complexity Classes (Second Graph)', fontsize=14)
plt.legend(fontsize=10)
plt.grid(True)

# Adjust layout
plt.tight_layout()

# Show the plots
plt.show()

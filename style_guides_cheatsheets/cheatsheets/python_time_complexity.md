# Python Big-O

## Profile to validate your assumptions in python

* `import cProfile; cProfile.run('function_to_test()', sort="ncalls")`
* `python -m cProfile -s ncalls .\program_to_validate.py`

Depending on how you run this, it will give you function call counts and processor time.

At the bottom of this file is some python code to experiment with call counts.

Sorting:

* `tottime` is the time that specific function is doing something.  
* `cumtime` is the cumulative time and includes the time the function is called, plus the time of all of the functions it calls.  
* `ncalls` as an integer, the number of times the function is called.

If you have a function, and you believe it function runs in `O(n)`: then `import cProfile; cProfile.run('function_to_test()', sort="ncalls")` should be equal to `function_to_test(x) = len(x)`.

## Common Big-O Notations

Big-O or asymptotic analysis relates the execution time to complete a process and its relationship to input size.

Input size is denoted by n.

**Example 1**
For example, if i give you 5 dice, ask you to roll them and then tell me the sum, you would:

```md
op_count    operation
1           sum_of_dice=0
1           4_dice_in_list = [die, die, die, die, die]
n           for die in 4_dice_in_list:
1               result=roll_die()
1               sum_of_dice=sum_of_dice + result
1           print(sum_of_dice)
```

This gives us `O(1 + 1 + n(1 + 1) + 1)`.
Which simplifies to `O(3 + 2n)`.
Asymptotic analysis is concerned with the dominant term, which is 2n.
The constant factors and lower-order terms are dropped, so the algorithm is classified as O(n).
This means the execution time grows linearly with the number of dice.
If 5 dice takes 1 minute, you can predict that 10 dice will take 2 minutes.

I have included many of the common `O()` below along with telltale signs and examples.  Below that are the expected `O()` for many common python operations.

Some caveats and mistakes i find myself making.

* **Linear Time** `O(n)` vs `O(m + n)`
    * Watch for accidentally dropping an `m` factor.  I have made this mistake a few times.  When looping over multiple lists, make sure you dont inadvertently drop on of the dominant terms.
* **Logarithmic Time** `O(log n)` vs **Linearithmic Time** `O(n log n)`
    * When I have an algorithm that continually cuts its input size by some factor (like Binary search on a sorted array), I think `O(log n)`.  If those results are then operated on (like a merge sort), dont forget to add the additional `n` term for `O(n log n)`.
    * Its common to hear Linearithmic Time `O(n log n)` referred to as `Log Linear` or `Linear Log`.

### Linear Time: `O(n)`

```md
 y=Execution Time
 ^
 |    *
 |   * 
 |  *  
 | *   
 |*    
 *-------------
        x=Input Size
```

* The execution time grows linearly with the size of the input.
* Examples:
  * Iterating through a list: `for x in list`
  * Finding the maximum or minimum value in an unsorted list
  * Appending to a list based on a list comprehension.  `m = []; [m.append(i) for i in a_list]`
    * `list.append()` is a common red flag that should trigger an analysis for direct assignment.
  * Pre-creating a list then assigning to it.  `l = [0] * len(data); for i, dat in enumerate(data): l[i] = dat`
    * Likewise this is a red flag.  Look to use a direct assignment if possible.

### Constant Time: `O(1)`

```plot
 y=Execution Time
 ^
 |*****
 |
 |
 |
 |
 *-------------
        x=Input Size
```

* The execution time is constant and does not change with the size of the input.
* Examples:
  * Accessing an array element by index: `arr[i]`
  * Inserting an element at the end of a list (amortized): `list.append(x)`
  * List direct assignment: `self.stack: list[str] = list(word)`
    * Note that a commonly used alternative `m = []; [m.append(i) for i in a_list]` is `O(n)` and much slower.
  * Numpy array. `import numpy as np; l = np.zeros(len(data))`

### Logarithmic Time: `O(log n)`

```plot
 y=Execution Time
 ^
 |*
 | *
 |  *
 |   *
 |    *
 *-------------
        x=Input Size
```

* The execution time grows logarithmically as the input size increases.
* As the size of the input increases, the time taken by the algorithm to execute grows at a rate that is logarithmic in proportion to the size of the input.
* As the input size increases, the execution time increases at a slower rate compared to linear growth.
* Typically arises in algorithms that repeatedly divide the input size by a constant factor in each step.
* Highly efficient for large inputs since the bigger the input, the bigger the savings.
* Examples:
  * Binary search on a sorted array
  * Inserting, deleting, or searching in a balanced binary search tree (e.g., AVL tree, Red-Black tree)

### Linearithmic Time: `O(n log n)`

```plot
 y=Execution Time
 ^
 |         *
 |        *
 |       *
 |      *
 |    *
 |  *
 |*
 *-------------
        x=Input Size
```

* I commonly hear this called `Linear Log` or `Log Linear`.
* Similar to `Logarithmic Time: O(log n)` but includes a linear component.  Often this component comes from a merging at the end of each logarithmic section.
* Is not always, but usually, especially with large inputs more efficient than `O(n^2)`.
* Algorithms that typically follow a pattern of dividing the problem into smaller subproblems, solving them recursively, and combining the results efficiently.
* The execution time grows in a combination of linear and logarithmic times.
* Examples:
  * Efficient sorting algorithms: Merge sort, Heapsort, and Timsort
  * Some divide-and-conquer algorithms

### Quadratic Time: `O(n^2)`

```plot
 y=Execution Time
 ^
 |            *
 |          *
 |        *
 |      *
 |    *
 |  *
 |*
 *-------------
        x=Input Size
```

* The execution time grows quadratically with the size of the input.
* The execution time rises as a sharp curve.
* Bad for larger inputs.
* Nested loops are an example of quadratic growth.
* For every n, do n times.
* Can work for small inputs.  If you just need a quick answer for a list of 10 elements.
* Examples:
  * Simple sorting algorithms: Bubble sort, Insertion sort, and Selection sort (in their worst cases)
  * Checking all pairs in a list (e.g., for finding duplicates)

### Cubic Time: `O(n^3)`

```plot
 y=Execution Time
 ^
 |                *
 |           *
 |       *
 |   *
 |*
 *------------------
        x=Input Size
```

* The execution time grows cubically with the size of the input.
* Examples:
  * Algorithms with three nested loops over the input data
  * Certain dynamic programming algorithms (e.g., Floyd-Warshall algorithm for all-pairs shortest paths)

### Polynomial Time: `O(n^k)`

```plot
 y=Execution Time
 ^
 |                *
 |           *
 |       *
 |   *
 |*
 *------------------
        x=Input Size
```

* The execution time grows polynomial with the size of the input, where `k` is a constant.
* Examples:
  * Algorithms with nested loops (more than three levels)

### Exponential Time: `O(2^n)`

```plot
 y=Execution Time
 ^
 |                *
 |             *
 |          *
 |       *
 |    *
 | *
 *------------------
        x=Input Size
```

* The execution time grows exponentially with the size of the input.
* Examples:
  * Recursive algorithms that solve a problem of size `n` by recursively solving two smaller problems of size `n-1`
  * Brute-force algorithms for the traveling salesman problem

### Factorial Time: `O(n!)`

```plot
 y=Execution Time
 ^
 |                          *
 |                    *
 |               *
 |          *
 |     *
 | *
 *------------------
        x=Input Size
```

* The execution time grows factorial with the size of the input.
* Examples:
  * Generating all permutations of a set
  * Certain brute-force algorithms for combinatorial problems

### Sublinear Time: `O(√n)`

```plot
 y=Execution Time
 ^
 |  *
 |
 |   *
 |     *
 |       *
 |          *
 |               *
 *------------------
        x=Input Size
```

* The execution time grows sublinearly with the size of the input.
* Examples:
  * Certain algorithms on square matrices
  * Jump search algorithm for sorted arrays

## Python Operations Time Complexity

### List Operations

* **Indexing**: `list[i]` - `O(1)`
* **Assignment**: `list[i] = x` - `O(1)`
* **Appending**: `list.append(x)` - Amortized `O(1)`
* **Pop (end)**: `list.pop()` - `O(1)`
* **Pop (arbitrary index)**: `list.pop(i)` - `O(n)`
* **Insert**: `list.insert(i, x)` - `O(n)`
* **Remove**: `list.remove(x)` - `O(n)`
* **Iteration**: `for i in list:` - `O(n)`
* **List Comprehension**: `[i for i in list]` - `O(n)`
* **Concatenation**: `list1 + list2` - `O(n + m)` (where `n` and `m` are the lengths of the lists)
* **Slicing**: `list[a:b]` - `O(b - a)`

### Dictionary Operations

* **Lookup**: `dict[key]` - Average `O(1)`
* **Assignment**: `dict[key] = value` - Average `O(1)`
* **Deletion**: `del dict[key]` - Average `O(1)`
* **Iteration**: `for key in dict:` - `O(n)` (where `n` is the number of items)

### Set Operations

* **Add**: `set.add(x)` - Average `O(1)`
* **Remove**: `set.remove(x)` - Average `O(1)`
* **Membership Test**: `x in set` - Average `O(1)`
* **Iteration**: `for item in set:` - `O(n)` (where `n` is the number of items)

### String Operations

* **Indexing**: `str[i]` - `O(1)`
* **Concatenation**: `str1 + str2` - `O(n + m)` (where `n` and `m` are the lengths of the strings)
* **Slicing**: `str[a:b]` - `O(b - a)`
* **Find**: `str.find(sub)` - `O(n * m)` (where `n` is the length of the string and `m` is the length of the substring)
* **Replace**: `str.replace(old, new)` - `O(n)`

### Deque Operations (from `collections` module)

* **Append**: `deque.append(x)` - `O(1)`
* **Appendleft**: `deque.appendleft(x)` - `O(1)`
* **Pop**: `deque.pop()` - `O(1)`
* **Popleft**: `deque.popleft()` - `O(1)`
* **Iteration**: `for i in deque:` - `O(n)` (where `n` is the number of items)

### Heap Operations (from `heapq` module)

* **Heapify**: `heapq.heapify(list)` - `O(n)`
* **Push**: `heapq.heappush(heap, item)` - `O(log n)`
* **Pop**: `heapq.heappop(heap)` - `O(log n)`
* **Pushpop**: `heapq.heappushpop(heap, item)` - `O(log n)`
* **Replace**: `heapq.heapreplace(heap, item)` - `O(log n)`

### General Iteration

* **Looping through a list**: `for i in list:` - `O(n)`
* **Looping through a dictionary**: `for key in dict:` - `O(n)`
* **Looping through a set**: `for item in set:` - `O(n)`

### General Sorting

* **Timsort (used by Python's built-in sort)**: `list.sort()` or `sorted(list)` - `O(n log n)`

### Examples of Compound Operations

* **List comprehension**: `[f(x) for x in list]` - `O(n * T_f)` (where `T_f` is the time complexity of the function `f`)
* **Dictionary comprehension**: `{k: v for k, v in iterable}` - `O(n * T_{iterable})` (where `T_{iterable}` is the time complexity of iterating over the original iterable)

### Summary

These complexities assume average-case scenarios for most operations, and some operations (especially in dictionaries and sets) can degrade to worse cases under certain conditions, such as poor hash functions leading to many collisions. However, in general, these are the complexities you will encounter in typical use cases.

### Python Call Counts Code

```python
"""
Sample for experimenting with O()
Do not consider any of these algorithms complete or correct.  
In some cases i am breaking things so we see results in a small input set.
I dont want to worry about max recursion depth.
Im using globals to simplify call counts and keeping call trees to a single number.
"""
import cProfile

CALLS = 0


def im_linear(x):
    """
    Is linear.  Calls itself len(x) times.
    """
    global CALLS  # never do this.  Im just doing it as a test and example.
    CALLS += 1
    if len(x) <= 1:
        return True
    im_linear(x[1:])


def im_constant(x) -> bool:
    global CALLS  # never do this.  Im just doing it as a test and example.
    CALLS += 1
    return True

def im_quadratic(x: list[int]):
    """
    Is quadratic. for each element, for each element, call.
    [       1          2           3           4       ]
    [    1 2 3 4    1 2 3 4     1 2 3 4      1 2 3 4   ]
    """
    global CALLS
    CALLS += 1
    if len(x) <= 1:
        return True
    
    im_quadratic(x[1:])
    im_quadratic(x[1:])


def im_logn(x):
    """
    calls itself log(len(x)) times.
    Does this by cutting itself in half on each loop
    with small inputs, it can be hard to see the difference between this and linear
    """
    global CALLS  # never do this.  Im just doing it as a test and example.
    CALLS += 1
    if len(x) <= 1:
        return True
    mid: int = len(x) // 2

    # Divide the list into two halves
    left_half: list[int] = x[:mid]
    right_half: list[int] = x[mid:]

    im_logn(left_half)   # Recursive call on the left half
    im_logn(right_half)  # Recursive call on the right half


def im_n_log_n(arr):  # -> Any | list[Any]:
    global CALLS  # never do this.  Im just doing it as a test and example.
    CALLS += 1
    if len(arr) <= 1:
        return arr

    # Divide the array into two halves
    mid = len(arr) // 2
    left_half = arr[:mid]
    right_half = arr[mid:]

    # Recursively sort each half
    left_half = im_n_log_n(left_half)
    right_half = im_n_log_n(right_half)

    # Merge the sorted halves
    return merge(left_half, right_half)


def merge(left, right):  # -> list[Any]:
    global CALLS  # never do this.  Im just doing it as a test and example.
    CALLS += 1

    result = []
    left_index = 0
    right_index = 0

    # Merge step giving the first n in O(n log n)
    while left_index < len(left) and right_index < len(right):
        if left[left_index] < right[right_index]:
            result.append(left[left_index])
            left_index += 1
        else:
            result.append(right[right_index])
            right_index += 1

    # Add any remaining elements from the left list
    result.extend(left[left_index:])

    # Add any remaining elements from the right list
    result.extend(right[right_index:])

    return result


def main():
    global CALLS
    l: list[int] = list(range(10))

    im_linear(l)
    print(f"im_linear made {CALLS} calls for an input size of {len(l)}.")
    CALLS = 0

    im_constant(l)
    print(f"im_constant made {CALLS} calls for an input size of {len(l)}.")
    CALLS = 0

    im_logn(l)
    print(f"im_logn made {CALLS} calls for an input size of {len(l)}.")
    CALLS = 0

    im_n_log_n(l)
    print(f"im_n_log_n made {CALLS} calls for an input size of {len(l)}.")
    CALLS = 0
    
    im_quadratic(l)
    print(f"im_quadratic made {CALLS} calls for an input size of {len(l)}.")
    CALLS = 0


if __name__ == "__main__":
    cProfile.run('main()', sort="ncalls")

```

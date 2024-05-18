# Python Big-O

## Common Big-O Notations

### Constant Time: `O(1)`

- The execution time is constant and does not change with the size of the input.
- Examples:
  - Accessing an array element by index: `arr[i]`
  - Inserting an element at the end of a list (amortized): `list.append(x)`

### Linear Time: `O(n)`

- The execution time grows linearly with the size of the input.
- Examples:
  - Iterating through a list: `for x in list`
  - Finding the maximum or minimum value in an unsorted list

### Logarithmic Time: `O(log n)`

- The execution time grows logarithmically as the input size increases.
- Examples:
  - Binary search on a sorted array
  - Inserting, deleting, or searching in a balanced binary search tree (e.g., AVL tree, Red-Black tree)

### Linearithmic Time: `O(n log n)`

- The execution time grows in a combination of linear and logarithmic times.
- Examples:
  - Efficient sorting algorithms: Merge sort, Heapsort, and Timsort
  - Some divide-and-conquer algorithms

### Quadratic Time: `O(n^2)`

- The execution time grows quadratically with the size of the input.
- Examples:
  - Simple sorting algorithms: Bubble sort, Insertion sort, and Selection sort (in their worst cases)
  - Checking all pairs in a list (e.g., for finding duplicates)

### Cubic Time: `O(n^3)`

- The execution time grows cubically with the size of the input.
- Examples:
  - Algorithms with three nested loops over the input data
  - Certain dynamic programming algorithms (e.g., Floyd-Warshall algorithm for all-pairs shortest paths)

### Polynomial Time: `O(n^k)`

- The execution time grows polynomially with the size of the input, where `k` is a constant.
- Examples:
  - Algorithms with nested loops (more than three levels)

### Exponential Time: `O(2^n)`

- The execution time grows exponentially with the size of the input.
- Examples:
  - Recursive algorithms that solve a problem of size `n` by recursively solving two smaller problems of size `n-1`
  - Brute-force algorithms for the traveling salesman problem

### Factorial Time: `O(n!)`

- The execution time grows factorially with the size of the input.
- Examples:
  - Generating all permutations of a set
  - Certain brute-force algorithms for combinatorial problems

### Sublinear Time: `O(√n)`

- The execution time grows sublinearly with the size of the input.
- Examples:
  - Certain algorithms on square matrices
  - Jump search algorithm for sorted arrays

## Python Operations Time Complexity

### List Operations

- **Indexing**: `list[i]` - `O(1)`
- **Assignment**: `list[i] = x` - `O(1)`
- **Appending**: `list.append(x)` - Amortized `O(1)`
- **Pop (end)**: `list.pop()` - `O(1)`
- **Pop (arbitrary index)**: `list.pop(i)` - `O(n)`
- **Insert**: `list.insert(i, x)` - `O(n)`
- **Remove**: `list.remove(x)` - `O(n)`
- **Iteration**: `for i in list:` - `O(n)`
- **List Comprehension**: `[i for i in list]` - `O(n)`
- **Concatenation**: `list1 + list2` - `O(n + m)` (where `n` and `m` are the lengths of the lists)
- **Slicing**: `list[a:b]` - `O(b - a)`

### Dictionary Operations

- **Lookup**: `dict[key]` - Average `O(1)`
- **Assignment**: `dict[key] = value` - Average `O(1)`
- **Deletion**: `del dict[key]` - Average `O(1)`
- **Iteration**: `for key in dict:` - `O(n)` (where `n` is the number of items)

### Set Operations

- **Add**: `set.add(x)` - Average `O(1)`
- **Remove**: `set.remove(x)` - Average `O(1)`
- **Membership Test**: `x in set` - Average `O(1)`
- **Iteration**: `for item in set:` - `O(n)` (where `n` is the number of items)

### String Operations

- **Indexing**: `str[i]` - `O(1)`
- **Concatenation**: `str1 + str2` - `O(n + m)` (where `n` and `m` are the lengths of the strings)
- **Slicing**: `str[a:b]` - `O(b - a)`
- **Find**: `str.find(sub)` - `O(n * m)` (where `n` is the length of the string and `m` is the length of the substring)
- **Replace**: `str.replace(old, new)` - `O(n)`

### Deque Operations (from `collections` module)

- **Append**: `deque.append(x)` - `O(1)`
- **Appendleft**: `deque.appendleft(x)` - `O(1)`
- **Pop**: `deque.pop()` - `O(1)`
- **Popleft**: `deque.popleft()` - `O(1)`
- **Iteration**: `for i in deque:` - `O(n)` (where `n` is the number of items)

### Heap Operations (from `heapq` module)

- **Heapify**: `heapq.heapify(list)` - `O(n)`
- **Push**: `heapq.heappush(heap, item)` - `O(log n)`
- **Pop**: `heapq.heappop(heap)` - `O(log n)`
- **Pushpop**: `heapq.heappushpop(heap, item)` - `O(log n)`
- **Replace**: `heapq.heapreplace(heap, item)` - `O(log n)`

### General Iteration

- **Looping through a list**: `for i in list:` - `O(n)`
- **Looping through a dictionary**: `for key in dict:` - `O(n)`
- **Looping through a set**: `for item in set:` - `O(n)`

### General Sorting

- **Timsort (used by Python's built-in sort)**: `list.sort()` or `sorted(list)` - `O(n log n)`

### Examples of Compound Operations

- **List comprehension**: `[f(x) for x in list]` - `O(n * T_f)` (where `T_f` is the time complexity of the function `f`)
- **Dictionary comprehension**: `{k: v for k, v in iterable}` - `O(n * T_{iterable})` (where `T_{iterable}` is the time complexity of iterating over the original iterable)

### Summary

These complexities assume average-case scenarios for most operations, and some operations (especially in dictionaries and sets) can degrade to worse cases under certain conditions, such as poor hash functions leading to many collisions. However, in general, these are the complexities you will encounter in typical use cases.

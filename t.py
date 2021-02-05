# Python3 implementation to find all
# Pairs possible from the given Array

# Function to prall possible
# pairs from the array
def printPairs(arr, n):

    # Nested loop for all possible pairs
    for i in range(n):
        for j in range(n):
            print("(", arr[i], ",", arr[j], ")", end=", ")

# Driver code


arr = [1, 2, 3, 4, 5]
n = len(arr)

printPairs(arr, n)

# This code is contributed by mohit kumar 29

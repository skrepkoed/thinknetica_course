def fib(fib1, fib2, amount, fibonacci = [fib1, fib2])
  fib_next = fib1 + fib2
  fibonacci << fib_next
  fib(fib2, fib_next,  amount,fibonacci,) unless fibonacci.size == amount
  fibonacci
end
first_fib = 0
second_fib = 1
amount = 100
print fib(first_fib, second_fib, amount)

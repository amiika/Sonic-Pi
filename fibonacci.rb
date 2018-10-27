
def fib num
  (1..num).inject([0,1]) { |fib| fib << fib.last(2).inject(:+)}
end


print fib(20)
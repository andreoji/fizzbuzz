class Fizzbuzzer
  def self.call(numbers)
    numbers.map{ |n| {number: n, value: fizzbuzz(n) } }
  end

  private
  def self.fizzbuzz(n)
    return 'fizzbuzz' if n % 15 == 0
    return 'fizz' if n % 3 == 0
    return 'buzz' if n % 5 == 0
    n 
  end
end

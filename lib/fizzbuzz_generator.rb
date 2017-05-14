class FizzbuzzGenerator
  MIN = 1
  MAX = 1_000_000_000_000

  def initialize(args={})
    @favourites = args[:favourites]
  end
  def numbers(page, per_page)
    current = current_page_numbers(page, per_page) 
    common = current & @favourites
    current.map{ |n| {number: n, value: fizzbuzz(n), fave: common.include?(n) } }
  end
  private
  def current_page_numbers(page, per_page)
    (from(page, per_page)..to(page, per_page)).to_a
  end
  def from(page, per_page)
    f = ((per_page * (page - 1)) + 1) 
    return MIN if f < MIN
    f
  end
  def to(page, per_page)
    t = (page * per_page)
    return MAX if t > MAX
    t
  end
  def fizzbuzz(n)
    return 'fizzbuzz' if n % 15 == 0
    return 'fizz' if n % 3 == 0
    return 'buzz' if n % 5 == 0
    n 
  end
end

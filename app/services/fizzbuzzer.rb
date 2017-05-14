require 'will_paginate/array'
class Fizzbuzzer
  PAGE = 1
  PER_PAGE = 100
  MAX = 1_000_000_000_000

  def self.call(params, favourites)
    page = get_page(params)
    per_page = get_per_page(params)
    WillPaginate::Collection.create(page, per_page, MAX) do |p|
      p.replace generate((per_page * (page - 1)) + 1, page * per_page, favourites)
    end 
  end

  private
  def self.generate(from, to, favourites)
    numbers = (from..to).to_a
    common = numbers & favourites
    numbers.map{ |n| {number: n, value: fizzbuzz(n), fave: common.include?(n) } }
  end

  def self.get_page(params)
    page = (params[:page] || PAGE).to_i
    return PAGE if page < 1
    page
  end

  def self.get_per_page(params)
    per_page = (params[:per_page] || PER_PAGE).to_i
    return PER_PAGE if per_page < 1
    per_page
  end
  def self.fizzbuzz(n)
    return 'fizzbuzz' if n % 15 == 0
    return 'fizz' if n % 3 == 0
    return 'buzz' if n % 5 == 0
    n 
  end
end

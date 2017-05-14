class NumbersPager
  PAGE = 1
  PER_PAGE = 100

  def initialize(args = {})
    @params = args[:params]
    @generator = args[:generator]
  end

  def call
    page = get_page(@params)
    per_page = get_per_page(@params)
    page = page_or_max_page(page, per_page)
    WillPaginate::Collection.create(page, per_page, FizzbuzzGenerator::MAX) do |p|
      p.replace @generator.numbers(page, per_page)
    end 
  end

  private
  def page_or_max_page(page, per_page)
    array = FizzbuzzGenerator::MAX.divmod(per_page)
    quotient = array[0]
    remainder = array[1]
    return quotient if (remainder == 0 and page > quotient)
    return (quotient + 1) if (remainder > 0 and page > (quotient + 1))
    return page
  end
  def get_page(params)
    page = (params[:page] || PAGE).to_i
    return PAGE if page < 1
    page
  end

  def get_per_page(params)
    per_page = (params[:per_page] || PER_PAGE).to_i
    return PER_PAGE if per_page < 1
    per_page
  end
end

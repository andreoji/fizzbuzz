class ExtendedFizzbuzzGenerator < FizzbuzzGenerator
  def initialize(args)
    @current_user_id = args[:current_user_id]
    @marked_as_favourites = args[:params][:marked_as_favourites]
    super(args)
  end
  def numbers(page, per_page)
    current = current_page_numbers(page, per_page)
    updates = FavouritesLogic.call(@marked_as_favourites, current, @favourites)

    Favourite.where("user_id = ?", @current_user_id).
      where(number: updates[:deleted_favourites]).
      delete_all unless updates[:deleted_favourites].empty?
    
    new_favourites = updates[:new_favourites].map { |n| {number: n, user_id: @current_user_id }}
    Favourite.create(new_favourites) unless new_favourites.empty?
    updated_favourites = Favourite.where("user_id = ?", @current_user_id).pluck(:number)
    common = current & updated_favourites
    current.map{ |n| {number: n, value: fizzbuzz(n), fave: common.include?(n) } }
  end
end

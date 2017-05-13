class FavouritesState
  def self.call(params, current_page_numbers, saved_favourites)
    marked_as_favourites = params[:marked_as_favourites]
    favourites_state = { new_favourites: [], removed_favourites: [] }
    return favourites_state if marked_as_favourites.nil?
    currently_displayed_favourites = saved_favourites & current_page_numbers
    marked = marked_as_favourites.map{ |n| n.to_i }
    favourites_state[:removed_favourites] = (currently_displayed_favourites - marked)
    favourites_state[:new_favourites] = (marked - saved_favourites)
    favourites_state
  end
end

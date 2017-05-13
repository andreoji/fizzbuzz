class FavouritesState
  def self.call(params, current_page_numbers, saved_favourites)
    marked_as_favourites = params[:marked_as_favourites]
    favourites_state = { new_favourites: [], deleted_favourites: [] }
    currently_displayed_favourites = saved_favourites & current_page_numbers
    if marked_as_favourites.nil?
      favourites_state[:deleted_favourites] = currently_displayed_favourites
    else 
      marked = marked_as_favourites.map{ |n| n.to_i }
      favourites_state[:deleted_favourites] = (currently_displayed_favourites - marked)
      favourites_state[:new_favourites] = (marked - saved_favourites)
    end
    favourites_state
  end
end

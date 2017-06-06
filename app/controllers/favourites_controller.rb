class FavouritesController < ApplicationController
  before_action :authorize

  def index
    current_user_id = session[:current_user_id]
    favourites = Favourite.where("user_id = ?", current_user_id).pluck(:number)
    numbers_pager = NumbersPager.new({params: params, generator: FizzbuzzGenerator.new(favourites: favourites)})
    @fizzbuzz_numbers = numbers_pager.call
  end
  
  def update_favourites
    current_user_id = session[:current_user_id]
    favourites = Favourite.where("user_id = ?", current_user_id).pluck(:number)
    numbers_pager = NumbersPager.new({params: params,
                                 generator: ExtendedFizzbuzzGenerator.new({favourites: favourites,
                                                                           params: params,
                                                                           current_user_id: current_user_id})})
    @fizzbuzz_numbers = numbers_pager.call
    redirect_back(fallback_location: favourites_path)
  end  

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def favourite_params
      params.require(:favourite).permit(:number).merge(user_id: session[:user_id])
    end
end

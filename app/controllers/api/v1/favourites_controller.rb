module Api
  module V1
    class FavouritesController < ApiController
      before_action :require_token_authentication
      after_action :set_link_headers, only: [:index]

      def index
        favourites = Favourite.where("user_id = ?", current_user.id).pluck(:number)
        numbers_pager = NumbersPager.new({params: params, generator: FizzbuzzGenerator.new(favourites: favourites)})
        @fizzbuzz_numbers = numbers_pager.call
        render json: @fizzbuzz_numbers
      end
      
      def update_favourites
        current_user_id = current_user.id
        favourites = Favourite.where("user_id = ?", current_user_id).pluck(:number)
        numbers_pager = NumbersPager.new({params: params,
                                     generator: ExtendedFizzbuzzGenerator.new({favourites: favourites,
                                                                               params: params,
                                                                               current_user_id: current_user_id})})
        begin
          @fizzbuzz_numbers = numbers_pager.call
        rescue => ex
          render_bad_request ex.message
        else
          set_link_headers
          render json: @fizzbuzz_numbers
        end
      end  

      private
        # Never trust parameters from the scary internet, only allow the white list through.
      def favourite_params
        params.require(:favourite).permit(:number)
      end

      def render_bad_request(message)
        errors = { errors: [ { detail: message } ] }
        render json: errors, status: :bad_request
      end

      def set_link_headers
        headers["X-Total-Pages"]   = @fizzbuzz_numbers.total_pages
        headers["X-Total-Entries"] = @fizzbuzz_numbers.total_entries
        headers["X-Per-Page"]      = @fizzbuzz_numbers.per_page
        headers["X-Current-Page"]  = @fizzbuzz_numbers.current_page
        headers["X-Next-Page"]     = @fizzbuzz_numbers.next_page     if @fizzbuzz_numbers.next_page
        headers["X-Previous-Page"] = @fizzbuzz_numbers.previous_page if @fizzbuzz_numbers.previous_page
      end
    end
  end
end

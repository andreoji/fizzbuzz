class FavouritesController < ApplicationController
  before_action :authorize, :set_favourite, only: [:update, :destroy, :show]
  # GET /favourites
  # GET /favourites.json
  def index
    current_user_id = session[:user_id]
    favourites = Favourite.where("user_id = ?", current_user_id).pluck(:number)
    numbers_pager = NumbersPager.new({params: params, generator: FizzbuzzGenerator.new(favourites: favourites)})
    @fizzbuzz_numbers = numbers_pager.call
  end
  
  def update_favourites
    current_user_id = session[:user_id]
    favourites = Favourite.where("user_id = ?", current_user_id).pluck(:number)
    numbers_pager = NumbersPager.new({params: params,
                                 generator: ExtendedFizzbuzzGenerator.new({favourites: favourites,
                                                                           params: params,
                                                                           current_user_id: current_user_id})})
    @fizzbuzz_numbers = numbers_pager.call
    redirect_back(fallback_location: favourites_path)
  end  
  # GET /favourites/1
  # GET /favourites/1.json
  def show
  end

  # GET /favourites/new
  def new
    @favourite = Favourite.new
  end

  # GET /favourites/1/edit
  def edit
  end

  # POST /favourites
  # POST /favourites.json
  def create
    @favourite = Favourite.new(favourite_params)
    respond_to do |format|
      if @favourite.save
        format.html { redirect_to @favourite, notice: 'Favourite was successfully created.' }
        format.json { render :show, status: :created, location: @favourite }
      else
        format.html { render :new }
        format.json { render json: @favourite.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /favourites/1
  # PATCH/PUT /favourites/1.json
  def update
    respond_to do |format|
      if @favourite.update(favourite_params)
        format.html { redirect_to @favourite, notice: 'Favourite was successfully updated.' }
        format.json { render :show, status: :ok, location: @favourite }
      else
        format.html { render :edit }
        format.json { render json: @favourite.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /favourites/1
  # DELETE /favourites/1.json
  def destroy
    @favourite.destroy
    respond_to do |format|
      format.html { redirect_to favourites_url, notice: 'Favourite was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_favourite
      @favourite = Favourite.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def favourite_params
      params.require(:favourite).permit(:number).merge(user_id: session[:user_id])
    end
end

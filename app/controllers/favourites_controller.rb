class FavouritesController < ApplicationController
  before_action :authorize, :set_favourite, only: [:update, :destroy, :show]

  # GET /favourites
  # GET /favourites.json
  def index
    puts "********page: #{params[:page]} ******"
    puts "********per_page: #{params[:per_page]} ******"
    puts "********pagination: #{params[:pagination]} ******"

    pagination = Pagination.call(params)
    current_page_numbers = pagination[:numbers]
    params[:page] = pagination[:page]
    params[:per_page] = pagination[:per_page]
    @saved_favourites = Favourite.where("user_id = ?", session[:user_id]).pluck(:number)
    favourites_state = FavouritesState.call(params, current_page_numbers, @saved_favourites)
    puts "********favourites_state: #{favourites_state.inspect} ******"
    @fizzbuzzes = Fizzbuzzer.call(current_page_numbers, @saved_favourites)
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
      params.require(:favourite).permit(:number, :favourite_numbers, :page, :per_page).merge(user_id: session[:user_id])
    end
end

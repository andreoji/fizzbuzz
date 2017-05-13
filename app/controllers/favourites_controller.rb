class FavouritesController < ApplicationController
  before_action :authorize, :set_favourite, only: [:update, :destroy, :show]

  # GET /favourites
  # GET /favourites.json
  def index
    puts "********page: #{params[:page]} ******"
    puts "********per_page: #{params[:per_page]} ******"
    puts "********pagination: #{params[:pagination]} ******"

    pagination = Pagination.call(params)
    params[:page] = pagination[:page]
    params[:per_page] = pagination[:per_page]
    current_page_numbers = pagination[:numbers]
    puts "********current_page_numbers: #{current_page_numbers.inspect} ******"
    marked_as_favourites = params[:favourite_numbers]
    puts "******marked_as_favourites: #{marked_as_favourites.inspect} *****"
    @saved_favourites = Favourite.where("user_id = ?", session[:user_id]).pluck(:number)
    puts "******saved favourites: #{@saved_favourites.inspect} *****"
    currently_displayed_favourites = @saved_favourites & current_page_numbers
    puts "******currently_displayed_favourites: #{currently_displayed_favourites.inspect} *****"
    unless marked_as_favourites.nil?
      removed_favourites = currently_displayed_favourites - marked_as_favourites.map{ |n| n.to_i }
      puts "*****removed: #{removed_favourites.inspect}****"
      new_favourites = marked_as_favourites.map{ |n| n.to_i } - @saved_favourites
      puts "*****new: #{new_favourites.inspect}****"
    end
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

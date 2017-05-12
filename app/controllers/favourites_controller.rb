class FavouritesController < ApplicationController
  before_action :authorize, :set_favourite, only: [:update, :destroy]

  PAGE = 1
  PER_PAGE = 10
  MAX = 1_000_000_000_000
  def next
    page = (params[:page] || PAGE).to_i
    per_page = (params[:per_page] || PER_PAGE).to_i
    first = page
    first = (((page - 1) * per_page) + page) if page > 1
    last = ((page * per_page) + page)
    numbers = (first..last).to_a
    session[:numbers] = numbers
    redirect_to favourites_path(:page => page, :per_page => per_page)
  end

  def previous 
    page = (params[:page] || PAGE).to_i
    per_page = (params[:per_page] || PER_PAGE).to_i
    first = page
    last = (per_page + 1)
    last = ((page - 1) * per_page) + (page - 1) if page > 1
    first = (last - per_page) if page > 1
    numbers = (first..last).to_a
    session[:numbers] = numbers
    redirect_to favourites_path(:page => page, :per_page => per_page)
  end
  # GET /favourites
  # GET /favourites.json
  def index
    session[:numbers] ||= (PAGE..(PER_PAGE + 1)).to_a 
    #@favourites = Favourite.where("user_id = ?", session[:user_id]).page(params[:page]).per(2)
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

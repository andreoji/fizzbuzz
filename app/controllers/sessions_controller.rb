class SessionsController < ApplicationController

  def create
    user = User.find_by_username(params[:username])
    if user && user.authenticate(params[:password])
      session[:current_user_id] = user.id
      redirect_to favourites_path 
    else
      redirect_to login_path 
    end
  end

  def destroy
    reset_session
    redirect_to login_path notice: 'Logged out'
  end

  def new
  end
end

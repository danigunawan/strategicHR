class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user
      if !user.confirmed_at
        flash[:alert] = "Email address has not been verified. Please click link in confirmation email to verify."
        render :new
      elsif user.authenticate(params[:password])
        session[:user_id] = user.id
        if params[:remember_me]
          cookies.permanent[:token] = user.token
        else
          cookies[:token] = user.token
        end
        redirect_to courses_path notice: "You are now logged in to Strategic HR by Dr. Bob."
      else
        flash[:alert] =  "Invalid user/password combination."
        render :new
      end
    else
      flash[:alert] =  "Invalid user/password combination."
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    cookies.delete(:token)
    redirect_to root_path, notice: "You are now logged out."
  end
end

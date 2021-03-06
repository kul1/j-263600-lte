class PasswordResetsController < ApplicationController

  def index
  end

  def create
    #user = User.find_by_email(params[:email])
    user = Jinda::User.where(:email => params[:email]).first

    user.send_password_reset if user
    redirect_to root_url, :ma_notice => "Email sent with password reset instructions."
  end

  def edit
    ## Deprecated syntax in rail 5
    ##@user = User.find_by_password_reset_token!(params[:id])
    @user = Jinda::User.where(:password_reset_token => params[:id]).first
  end

  def update
    ##@user = User.find_by_password_reset_token!(params[:id])
    @user = Jinda::User.where(:password_reset_token => params[:id]).first
    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path, :alert => "Password &crarr;
      reset has expired."
    elsif @user.update_attributes(params[:user])
      redirect_to root_url, :notice => "Password has been reset."
    else
      render :edit
    end
  end

end


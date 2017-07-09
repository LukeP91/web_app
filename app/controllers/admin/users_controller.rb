class Admin::UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    authorize @user
  end

  def index
    @users = User.all
    authorize @users
  end

  def edit
    @user = User.find(params[:id])
    authorize @user
  end

  def update
    @user = User.find(params[:id])
    authorize @user
    if @user.update_attributes(user_params)
      redirect_to admin_user_path
    else
      render 'edit'
    end
  end

  private

  def user_params
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].delete(:password_confirmation)
      params[:user].delete(:password)
    end
    params.require(:user).permit(:email, :first_name, :last_name, :age, :gender,
                                 :admin, :password, :password_confirmation)
  end
end

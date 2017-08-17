class Api::UsersController < ApplicationController
  def index
    users = User.order(:id).paginate(page: page, per_page: per_page)
    response.headers["X-Total-Count"] = User.count
    render json: UsersSerializer.new(users).serialize, status: :ok
  end

  def show
    user = User.find(params[:id])
    render json: UserSerializer.new(user).serialize, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: {errors: [{status: 404, code: 'Not found', title: 'User not found'}]}, status: :not_found
  end

  def create
    user = User.new(user_params)
    user.password = user.password_confirmation = Devise.friendly_token.first(8)
    user.organization = Organization.first
    if user.save
      render json: user, status: :created
    end
  end

  def edit
    user = User.find(params[:id])
    if user.update(user_params)
      render json: user, status: :ok
    end
  end


  private

  def user_params
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].delete(:password_confirmation)
      params[:user].delete(:password)
    end

    params.require(:user).permit(
      :email, :first_name, :last_name, :age, :gender, :admin, :password,
      :password_confirmation, interest_ids: []
    )
  end

  def page
    params[:page] || 1
  end

  def per_page
    params[:per_page] || User.per_page
  end
end
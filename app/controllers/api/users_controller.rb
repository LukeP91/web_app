class Api::UsersController < ApplicationController
  class AuthorizationTokenMissing < StandardError; end

  rescue_from ActiveRecord::RecordNotFound, with: :user_not_found
  rescue_from AuthorizationTokenMissing, with: :unauthenticated_user

  before_action :authenticate_user_token!, only: [:index]


  def index
    users = User.in_organization(@user.organization).order(:id).paginate(page: page, per_page: per_page)
    render json: UsersSerializer.new(users, page, per_page).serialize, status: :ok
  end

  def show
    user = User.find(params[:id])
    render json: UserSerializer.new(user).serialize, status: :ok
  end

  def create
    user = User.new(user_params)
    user.password = user.password_confirmation = Devise.friendly_token.first(8)
    user.organization = Organization.first

    if user.save
      user.send_reset_password_instructions
      render json: UserSerializer.new(user).serialize, status: :created
    else
      render json: { errors: user.errors.messages }, status: :bad_request
    end
  end

  def update
    user = User.find(params[:id])

    if user.update(user_params)
      render json: UserSerializer.new(user).serialize, status: :ok
    else
      render json: { errors: user.errors.messages }, status: :bad_request
    end
  end

  def destroy
    user = User.find(params[:id])

    if user.delete
      render json: {}, status: :no_content
    end
  end

  private

  def user_params
    params.require(:data).require(:attributes).permit(
      :email, :first_name, :last_name, :age, :gender, :admin, interest_ids: []
    )
  end

  def page
    params.fetch(:page, 1).to_i
  end

  def per_page
    params.fetch(:per_page, User.per_page).to_i
  end

  def user_not_found
    render json: { errors: [{ status: 404, code: 'Not found', title: 'User not found' }] }, status: :not_found
  end

  def authenticate_user_token!
    payload = JsonWebToken.decode(authentication_token)
    @user = User.find(payload[:id])
  end

  def authentication_token
    token = request.headers['Authorization']

    if token.nil?
      raise AuthorizationTokenMissing
    end

    token.gsub('Bearer: ', '')
  end

  def unauthenticated_user
    render json: { errors: [{ status: 401, code: 'Unauthorized', title: 'Unauthorized' }] }, status: :unauthorized
  end
end


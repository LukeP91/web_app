class Api::ApiController < ApplicationController
  respond_to :json

  class AuthorizationTokenMissing < StandardError; end
  class InvalidHeader < StandardError; end
  class InvalidToken < StandardError; end

  rescue_from ActiveRecord::RecordNotFound, with: :user_not_found
  rescue_from AuthorizationTokenMissing, with: :unauthorized_user
  rescue_from InvalidHeader, with: :bad_request
  rescue_from InvalidToken, with: :unauthorized_user

  skip_before_action :verify_authenticity_token
  before_action :authenticate_user_by_jwt_token!

  private

  def authenticate_user_by_jwt_token!
    payload = JsonWebToken.decode(authentication_token)
    raise InvalidToken unless payload

    user = User.find(payload[:id])
    sign_in(user)
  end

  def authentication_token
    authorization_header = request.headers['Authorization']
    raise AuthorizationTokenMissing unless authorization_header

    jwt_token = authorization_header.gsub!('Bearer: ', '')
    raise InvalidHeader unless jwt_token

    jwt_token
  end

  def unauthorized_user
    render json: { errors: [{ status: 401, code: 'Unauthorized', title: 'Unauthorized' }] }, status: :unauthorized
  end

  def bad_request
    render json: { errors: [{ status: 400, code: 'Bad request', title: 'Bad request' }] }, status: :bad_request
  end

  def user_not_authorized
    render json: { errors: [{ status: 403, code: 'Forbidden', title: 'Forbidden' }] }, status: :forbidden
  end

  def user_not_found
    render json: { errors: [{ status: 404, code: 'Not found', title: 'User not found' }] }, status: :not_found
  end
end

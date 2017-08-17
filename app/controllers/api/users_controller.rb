class Api::UsersController < ApplicationController
  def index
    users = User.order(:id).paginate(page: page, per_page: per_page)
    user_count_header
    pagination_header
    render json: UsersSerializer.new(users).serialize, status: :ok
  end

  def show
    user = User.find(params[:id])
    render json: UserSerializer.new(user).serialize, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { errors: [{ status: 404, code: 'Not found', title: 'User not found' }] }, status: :not_found
  end

  def create
    user = User.new(user_params)
    user.password = user.password_confirmation = Devise.friendly_token.first(8)
    user.organization = Organization.first
    if user.save
      render json: UserSerializer.new(user).serialize, status: :created
    end
  end

  def update
    user = User.find(params[:id])
    if user.update(user_params)
      render json: UserSerializer.new(user).serialize, status: :ok
    end
  end

  private

  def user_params
    if params[:data][:attributes][:password].blank? && params[:data][:attributes][:password_confirmation].blank?
      params[:data][:attributes].delete(:password_confirmation)
      params[:data][:attributes].delete(:password)
    end

    params.require(:data).require(:attributes).permit(
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

  def user_count_header
    response.headers['X-Total-Count'] = User.count
  end

  def pagination_header
    response.headers['Link'] = create_pagination_links.join(', ')
  end

  def create_pagination_links
    pagination_links = []
    page_numbers.each do |link|
      pagination_links << "<#{admin_users_url}?page=#{link.last}&per_page=#{per_page}>; rel=\"#{link.first}\""
    end
    pagination_links
  end

  def page_numbers
    pages = {}
    pages[:first] = 1 if current_page > 1
    pages[:last] = total_pages if total_pages > 1 && current_page < total_pages
    pages[:prev] = current_page - 1 if current_page > 1
    pages[:next] = current_page + 1 if current_page < total_pages && total_pages > 1
    pages
  end

  def current_page
    page.to_i
  end
  def total_pages
    User.pages(per_page)
  end
end

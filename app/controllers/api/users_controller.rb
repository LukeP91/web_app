class Api::UsersController < Api::ApiController
  def index
    users = User.in_organization(current_organization).order(:id).paginate(page: page, per_page: per_page)

    authorize users

    render json: UsersSerializer.new(users, page, per_page).serialize, status: :ok
  end

  def show
    user = User.in_organization(current_organization).find(params[:id])

    authorize user

    render json: UserSerializer.new(user).serialize, status: :ok
  end

  def create
    user = User.new(user_params)
    user.password = user.password_confirmation = Devise.friendly_token.first(8)
    user.organization = current_organization

    authorize user

    if user.save
      user.send_reset_password_instructions
      render json: UserSerializer.new(user).serialize, status: :created
    else
      render json: { errors: user.errors.messages }, status: :bad_request
    end
  end

  def update
    user = User.in_organization(current_organization).find(params[:id])

    authorize user

    if user.update(user_params)
      render json: UserSerializer.new(user).serialize, status: :ok
    else
      render json: { errors: user.errors.messages }, status: :bad_request
    end
  end

  def destroy
    user = User.in_organization(current_organization).find(params[:id])

    authorize user

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
end

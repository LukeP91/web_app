class Admin::UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    user = User.in_organization(current_organization).find(params[:id])
    authorize user
    render :show, locals: { user: user }
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_users_path
  end

  def index
    if (params[:search])
      users = User.in_organization(current_organization).search_by(params[:search][:search]).order(:email)
    else
      users = User.in_organization(current_organization).order(:email)
    end
    authorize users
    render :index, locals: { users: users }
  end

  def new
    user = User.new
    authorize user
    render :new, locals: { user: user }
  end

  def create
    interest_ids = params[:user].delete(:interest_ids)
    user = User.new(user_params)
    user.password = 'secret'
    user.password_confirmation = 'secret'
    user.organization = current_user.organization
    authorize user

    if user.save
      user.interest_ids = interest_ids
      redirect_to admin_user_path(user)
    else
      render :new, locals: { user: user }
    end
  end

  def edit
    user = User.in_organization(current_organization).find(params[:id])
    authorize user
    render :edit, locals: { user: user }
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_users_path
  end

  def update
    user = User.in_organization(current_organization).find(params[:id])
    authorize user
    if user.update(user_params)
      redirect_to admin_user_path(user)
    else
      render :edit, locals: { user: user }
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_users_path
  end

  def destroy
    user = User.in_organization(current_organization).find(params[:id])
    authorize user
    user.destroy
    redirect_to admin_users_path
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_users_path
  end

  def export
    users = User.in_organization(current_organization)
    respond_to do |format|
      format.csv do
        send_data ExportUsersAsCSV.export(users),
                  filename: "users_export-#{Date.today}.csv"
      end
    end
  end

  def send_email
    user = User.in_organization(current_organization).find(params[:id])
    authorize user
    SendEmail.send_to(current_user, user)
    redirect_to admin_users_path
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_users_path
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

  helper_method def gender_list
    %w[male female]
  end
end

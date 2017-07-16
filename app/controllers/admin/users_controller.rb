class Admin::UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    user = User.find(params[:id])
    authorize user
    render 'admin/users/show', locals: { user: user}
  end

  def index
    q = User.ransack(params[:q])
    users = q.result(distinct: true).order(:email)
    authorize users
    render 'admin/users/index', locals: { q: q, users: users}
  end

  def new
    user = User.new
    interest = user.interests.build
    render 'admin/users/new', locals: { user: user, interest: interest }
  end

  def create
    user = User.new(user_params)
    user.password = 'secret'
    user.password_confirmation = 'secret'

    if user.save
      redirect_to admin_user_path(user)
    else
      render 'new'
    end
  end

  def edit
    user = User.find(params[:id])
    authorize user
    render 'admin/users/edit', locals: { user: user}
  end

  def update
    user = User.find(params[:id])
    authorize user
    if user.update_attributes(user_params)
      redirect_to admin_user_path
    else
      render 'edit'
    end
  end

  def destroy
    user = User.find(params[:id])
    authorize user
    user.destroy
    redirect_to admin_users_path
  end

  def export
    users = User.all
    respond_to do |format|
      format.csv do
        send_data ExportUsersAsCSV.export(users),
                  filename: "users_export-#{Date.today}.csv"
      end
    end
  end

  def send_email
    user = User.find(params[:id])
    SendEmail.send_to(current_user, user)
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
      :password_confirmation, interests_attributes: [
        :id, :name, :category, :_destroy
      ])
  end

  helper_method def gender_list
    ["male", "female"]
  end
end

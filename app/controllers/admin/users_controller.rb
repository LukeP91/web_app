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
    users = search_users.page params[:page]
    authorize users
    render :index, locals: { users: users }
  end

  def new
    user = User.new
    authorize user
    render :new, locals: { user: user }
  end

  def create
    user = User.new(user_params)
    user.password = user.password_confirmation = Devise.friendly_token.first(8)
    user.organization = current_user.organization
    authorize user

    if user.save
      flash[:notice] = t('admin.notices.user_created')
      user.send_reset_password_instructions.deliver_later
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
      flash[:notice] = t('admin.notices.user_updated')
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
    flash[:notice] = t('admin.notices.user_deleted')
    redirect_to admin_users_path
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_users_path
  end

  def export
    users = User.in_organization(current_organization)
    respond_to do |format|
      format.csv do
        send_data ExportUsersAsCSV.new(users).call,
                  filename: "users_export-#{Date.today}.csv"
      end
    end
  end

  def send_email
    user = User.in_organization(current_organization).find(params[:id])
    authorize user
    SendEmail.new(current_user, user).call
    respond_to do |format|
      format.js
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_users_path
  end

  def welcome_email
    authorize current_user
    SendWelcomeEmail.new(current_user).call
    respond_to do |format|
      format.js
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

  def search_params
    params.fetch(:search, {}).fetch(:text, nil)
  end

  def search_users
    users = User.in_organization(current_organization).order(:email)
    search_params.present? ? users.search_by(search_params) : users
  end

  helper_method def gender_list
    %w[male female]
  end
end

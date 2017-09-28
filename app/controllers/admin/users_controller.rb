class Admin::UsersController < ApplicationController
  before_action :authenticate_user!

  rescue_from ActiveRecord::RecordNotFound, with: :user_not_found

  def show
    user = User.in_organization(current_organization).find(params[:id])
    authorize user
    render :show, locals: { user: user }
  end

  def index
    users = search_users.page params[:page]
    users_by_age = UsersByAge.result_for(organization: current_organization)
    authorize users
    render :index, locals: { users: users, users_by_age: users_by_age }
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
      user.send_reset_password_instructions
      broadcast_user
      Broadcast::UpdateCategoriesStats.call(organization: current_organization)
      redirect_to admin_user_path(user)
    else
      render :new, locals: { user: user }
    end
  end

  def edit
    user = User.in_organization(current_organization).find(params[:id])
    authorize user
    render :edit, locals: { user: user }
  end

  def update
    user = User.in_organization(current_organization).find(params[:id])
    authorize user
    if user.update(user_params)
      Broadcast::UpdateCategoriesStats.call(organization: current_organization)
      flash[:notice] = t('admin.notices.user_updated')
      redirect_to admin_user_path(user)
    else
      render :edit, locals: { user: user }
    end
  end

  def destroy
    user = User.in_organization(current_organization).find(params[:id])
    authorize user
    user.destroy
    flash[:notice] = t('admin.notices.user_deleted')
    redirect_to admin_users_path
  end

  def export
    users = User.in_organization(current_organization)
    respond_to do |format|
      format.csv do
        send_data ExportUsersAsCSV.call(users),
                  filename: "users_export-#{Date.today}.csv"
      end
    end
  end

  def send_email
    user = User.in_organization(current_organization).find(params[:id])
    authorize user
    SendEmail.call(current_user, user)
    respond_to do |format|
      format.js
    end
  end

  def welcome_email
    authorize current_user
    SendWelcomeEmail.call(current_user)
    respond_to do |format|
      format.js
    end
  end

  def send_welcome_sms
    user = User.in_organization(current_organization).find(params[:id])
    authorize user
    UserNotifications::SmsSender.call(to: user.mobile_phone, message: "Welcome #{user.full_name}!")
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
      :email, :first_name, :last_name, :age, :gender, :mobile_phone, :admin, :password,
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

  def broadcast_user
    ActionCable.server.broadcast(
      'users',
      users_by_age: UsersByAge.result_for(organization: current_organization)
    )
  end

  def user_not_found
    redirect_to admin_users_path
  end

  helper_method def gender_list
    %w[male female]
  end
end

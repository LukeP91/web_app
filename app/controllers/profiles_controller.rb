class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show; end

  def edit; end

  def update
    if current_user.update(user_params)
      Broadcast::UpdateCategoriesStats.call(organization: current_organization)
      redirect_to root_path
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :age, :gender, interest_ids: [])
  end

  helper_method def gender_list
    %w[male female]
  end
end

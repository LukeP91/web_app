class ProfilesController < ApplicationController
  def show
  end

  def edit
  end

  def update
    if current_user.update_attributes(user_params)
      redirect_to profile_path
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :age, :gender)
  end
end
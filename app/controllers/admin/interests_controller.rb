class Admin::InterestsController < ApplicationController
  before_action :authenticate_user!

  def show
    interest = Interest.find(params[:id])
    authorize interest
    render :show, locals: { interest: interest }
  end

  def index
    interests = Interest.all
    authorize interests
    render :index, locals: { interests: interests }
  end

  def new
    interest = Interest.new
    authorize interest
    render :new, locals: { interest: interest }
  end

  def create
    interest = Interest.new(interest_params)
    authorize interest

    if interest.save
      redirect_to admin_interest_path(interest)
    else
      render :new
    end
  end

  def edit
    interest = Interest.find(params[:id])
    authorize interest
    render :edit, locals: { interest: interest }
  end

  def update
    interest = Interest.find(params[:id])
    authorize interest

    if interest.update(interest_params)
      redirect_to admin_interest_path(interest)
    else
      render :edit, locals: { interest: interest }
    end
  end

  def destroy
    interest = Interest.find(params[:id])
    authorize interest
    interest.destroy
    redirect_to admin_interest_path
  end

  private

  def interest_params
    params.require(:interest).permit(:name, :category_id)
  end
end

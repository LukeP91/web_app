class Admin::CategoriesController < ApplicationController
  before_action :authenticate_user!

  def show
    category = Category.in_organization(current_organization).find(params[:id])
    authorize category
    render :show, locals: { category: category }
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_categories_path
  end

  def index
    categories = Category.in_organization(current_organization)
    users_count_per_category = UsersCountPerCategory.result_for(organization: current_organization)
    authorize categories
    render :index, locals: { categories: categories, users_count_per_category: users_count_per_category }
  end

  def new
    category = Category.new
    authorize category
    render :new, locals: { category: category }
  end

  def create
    category = Category.new(category_params)
    authorize category

    if category.save
      redirect_to admin_category_path(category)
    else
      render :new
    end
  end

  def edit
    category = Category.in_organization(current_organization).find(params[:id])
    authorize category
    render :edit, locals: { category: category }
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_categories_path
  end

  def update
    category = Category.in_organization(current_organization).find(params[:id])
    authorize category

    if category.update(category_params)
      redirect_to admin_category_path(category)
    else
      render :edit
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_categories_path
  end

  def destroy
    category = Category.in_organization(current_organization).find(params[:id])
    authorize category
    category.destroy
    redirect_to admin_categories_path
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_categories_path
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end

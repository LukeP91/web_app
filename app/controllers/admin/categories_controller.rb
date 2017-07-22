class Admin::CategoriesController < ApplicationController
  before_action :authenticate_user!

  def show
    category = Category.find(params[:id])
    authorize category
    render :show, locals: { category: category }
  end

  def index
    categories = Category.all
    authorize categories
    render :index, locals: { categories: categories }
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
    category = Category.find(params[:id])
    authorize category
    render :edit, locals: { category: category }
  end

  def update
    category = Category.find(params[:id])
    authorize category

    if category.update_attributes(category_params)
      redirect_to admin_category_path(category)
    else
      render :edit
    end
  end

  def destroy
    category = Category.find(params[:id])
    authorize category
    category.destroy
    redirect_to admin_categories_path
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end

class Admin::SourcesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :user_not_found

  def index
    sources = Source.in_organization(current_organization)
    authorize sources
    render :index, locals: { sources: sources }
  end

  def new
    source = Source.new
    authorize source
    render :new, locals: { source: source }
  end

  def create
    source = Source.new(source_params)
    authorize source
    source.organization = current_user.organization
    if source.save
      redirect_to admin_sources_path
    else
      render :new, locals: { source: source }
    end
  end

  def destroy
    source = Source.in_organization(current_organization).find(params[:id])
    authorize source
    source.destroy
    redirect_to admin_sources_path
  end

  private

  def source_params
    params.require(:source).permit(:name)
  end

  def user_not_found
    redirect_to admin_sources_path
  end
end

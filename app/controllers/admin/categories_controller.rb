class Admin::CategoriesController < ApplicationController
  authorize_resource
  before_action :load_category, only: %i(edit update destroy)

  def index
    @categories = Category.parent_categories.sort_categories
                          .paginate page: params[:page],
                           per_page: Settings.perpage
  end

  def new
    @parent_categories = Category.parent_categories
    @category = Category.new
  end

  def create
    @category = Category.new category_params
    if @category.save
      flash[:success] = t "controllers.admin.categories.add_success"
      redirect_to admin_categories_path
    else
      flash[:danger] = t "controllers.admin.categories.add_fail"
      render :new
    end
  end

  def edit; end

  def update
    if @category.update_attributes category_name
      flash[:success] = t "controllers.admin.categories.update_success"
      redirect_to admin_categories_path
    else
      render :edit
    end
  end

  def destroy
    if @category.destroy
      flash[:success] = t "controllers.admin.categories.delete_success"
    else
      flash[:danger] = t "controllers.admin.categories.delete_fail"
    end
    redirect_to request.referer
  end

  private

  def category_params
    params.require(:category).permit(:name, :parent_id)
  end

  def category_name
    params.require(:category).permit(:name, :id)
  end

  def load_category
    @category = Category.find_by id: params[:id]
    return if @category
    flash[:danger] = t ".not_found_category"
    redirect_to root_path
  end
end

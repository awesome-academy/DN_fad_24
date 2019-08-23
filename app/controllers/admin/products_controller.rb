class Admin::ProductsController < ApplicationController
  authorize_resource
  before_action :load_product, only: %i(edit update destroy)
  before_action :load_categories, only: %i(edit new)

  def index
    @products = Product.sort_products.paginate page: params[:page],
      per_page: Settings.perpage
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new product_params
    if @product.save
      flash[:success] = t "controllers.admin.products.add_success"
      redirect_to admin_products_path
    else
      flash[:danger] = t "controllers.admin.products.add_fail"
      render :new
    end
  end

  def edit; end

  def update
    if @product.update_attributes product_params
      flash[:success] = t "controllers.admin.products.update_success"
      redirect_to admin_products_path
    else
      render :edit
    end
  end

  def destroy
    if @product.destroy
      flash[:success] = t "controllers.admin.products.delete_success"
    else
      flash[:danger] = t "controllers.admin.products.delete_fail"
    end
    redirect_to admin_products_path
  end

  private

  def product_params
    params.require(:product).permit(:name, :description, :detail,
      :picture, :price, :status, :category_id)
  end

  def load_product
    @product = Product.find_by id: params[:id]
    return if @product
    flash[:danger] = t ".not_found_product"
    redirect_to root_path
  end

  def load_categories
    @categories = Category.sort_categories
    return if @categories
    flash[:danger] = t ".not_found_category"
    redirect_to root_path
  end
end

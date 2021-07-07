class StaticPagesController < ApplicationController
  def home
    @q = Product.ransack(params[:q])
    @products = @q.result.sort_products.paginate page: params[:page],
      per_page: Settings.perpage_12
    @categories = Category.sort_categories
    return if @products.present?
    flash[:danger] = t "controllers.search_fail"
  end

  def help; end

  def about; end

  def contact; end
end
dong nay dungsadasda	
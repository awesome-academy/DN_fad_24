class OrdersController < ApplicationController
  authorize_resource

  def new
    list_product check_cookie_cart
    return @order = Order.new if @products.any?
    flash[:danger] = t "controllers.orders.product_cart_empty"
    redirect_to root_path
  end

  def create
    list_product check_cookie_cart
    @order = Order.new order_params.merge(user_id: current_user.id,
      status: :order_success)
    Order.transaction do
      @order.save!
      detail_order_params @products
      @order.send_order_to_email
      flash[:success] = t "controllers.orders.order_success"
      redirect_to root_path
    end
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = t "controllers.orders.order_fail"
    render :new
  end

  private
  def order_params
    params.require(:order).permit(:name, :phone, :address)
  end

  def detail_order_params products
    products.each do |p|
      @detail_orders = @order.detail_orders.new(product_id: p.id,
        quantity: p.total_quantity, current_price: p.price)
      @detail_orders.save
    end
    cookies.delete :products
  end
end

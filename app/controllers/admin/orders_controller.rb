class Admin::OrdersController < ApplicationController
  authorize_resource
  before_action :load_order, only: %i(edit update show)

  def index
    @orders = Order.sort_orders.paginate page: params[:page],
      per_page: Settings.perpage
  end

  def show
    @detail_orders = @order.detail_orders
    return if @detail_orders
    flash[:danger] = t "controllers.orders_history.not_found"
    redirect_to admin_orders_path
  end

  def edit; end

  def update
    case statuses(order_params[:status])
    when statuses(:order_success)
      key = statuses(:order_success)
    when statuses(:delivered)
      key = statuses(:delivered)
    else
      redirect_fail
      return
    end
    set_status key
    redirect_success
  end

  private
  def load_order
    @order = Order.find_by id: params[:id]
    return if @order
    flash[:danger] = t ".not_found_order"
    redirect_to root_path
  end

  def order_params
    params.require(:order).permit(:status)
  end

  def statuses status
    Order.statuses[status].to_s
  end

  def set_status key
    if key == statuses(:order_success)
      @order.order_success!
    elsif key == statuses(:delivered)
      @order.delivered!
      @order.send_email_order_finish if @order.delivered?
    end
  rescue ArgumentError
    redirect_error
  end

  def redirect_success
    flash[:success] = t "controllers.admin.orders_history.update_order_success"
    redirect_to admin_orders_path
  end

  def redirect_fail
    flash[:danger] = t "controllers.admin.orders_history.update_order_fail"
    redirect_to admin_orders_path
  end
end

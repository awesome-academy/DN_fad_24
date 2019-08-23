class Admin::UsersController < ApplicationController
  before_action :load_user, except: %i(create new index)
  authorize_resource

  def index
    @users = User.sort_users.paginate page: params[:page],
      per_page: Settings.perpage
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t "controllers.admin.users.add_success"
      redirect_to admin_users_path
    else
      flash[:danger] = t "controllers.admin.users.add_fail"
      render :new
    end
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "controllers.admin.users.update_success"
      redirect_to admin_users_path
    else
      flash[:danger] = t "controllers.admin.users.update_fail"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "controllers.admin.users.destroy_success"
    else
      flash[:danger] = t "controllers.admin.users.destroy_fail"
    end
    redirect_to request.referrer
  end

  private
  def user_params
    params.require(:user).permit(:name, :picture, :email, :phone,
      :password, :role)
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:warning] = t "controllers.admin.users.find_fail"
    redirect_to root_path
  end
end

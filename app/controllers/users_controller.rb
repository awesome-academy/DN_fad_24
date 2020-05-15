class UsersController < ApplicationController
  authorize_resource
  before_action :load_user, only: %i(show)

  def show; end
  private

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t "controllers.users.login_please"
    redirect_to root_path
  end
end

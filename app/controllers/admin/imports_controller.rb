class Admin::ImportsController < ApplicationController
  def index
    @import = User.new
  end

  def create
    if params[:file].present?
      User.import_file params[:file]
      redirect_to root_path
    else
      flash[:danger] = t "controllers.import.not_file"
      redirect_to admin_imports_path
    end
  end
end

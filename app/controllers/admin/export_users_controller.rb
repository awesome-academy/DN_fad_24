class Admin::ExportUsersController < ApplicationController
  def index
    return unless current_user.present?
    if current_user.admin?
      csv = ExportUser.new User.sort_users, User::CSV_ATTRIBUTES
      respond_to do |format|
        format.csv do
          send_data csv.perform,
            filename: "users-#{Date.today}.csv"
        end
      end
    else
      flash[:danger] = t "controllers.export_fail"
      redirect_to root_path
    end
  end
end

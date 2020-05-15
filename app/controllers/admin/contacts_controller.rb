class Admin::ContactsController < ApplicationController
  authorize_resource
  before_action :load_contact, only: %i(edit update)

  def index
    @q = Contact.ransack(params[:q])
    @contacts = @q.result.sort_contacts.paginate page: params[:page],
      per_page: Settings.perpage
    return if @contacts.present?
    flash[:danger] = t "controllers.search_fail"
  end

  def edit; end

  def update
    if @contact.update_attributes contact_params
      flash[:success] = t "controllers.admin.contacts.update_success"
      redirect_to admin_contacts_path
    else
      flash[:danger] = t "controllers.admin.contacts.update_fail"
      render :edit
    end
  end

  private
  def load_contact
    @contact = Contact.find_by id: params[:id]
    return if @contact
    flash[:danger] = t ".not_found_contact"
    redirect_to admin_contacts_path
  end

  def contact_params
    params.require(:contact).permit(:status)
  end
end

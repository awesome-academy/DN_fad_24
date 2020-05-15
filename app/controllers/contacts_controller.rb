class ContactsController < ApplicationController
  authorize_resource

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new contact_params.merge(user_id: current_user.id)
    if @contact.save
      flash[:success] = t "controllers.contacts.add_success"
      redirect_to root_path
    else
      flash[:danger] = t "controllers.contacts.add_fail"
      render :new
    end
  end

  private
  def contact_params
    params.require(:contact).permit(:name, :email, :phone,
      :food_name, :picture, :description)
  end
end

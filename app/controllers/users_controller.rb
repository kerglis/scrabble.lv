class UsersController < BaseController
  resource_controller
  
  before_filter :authenticate_user!

  update.wants.html do
    redirect_to user_url
  end

  def show
    load_object
    render :edit
  end


private
  
  def object
    @object ||= current_user
  end
  
end
class UsersController < BaseController

  inherit_resources
  #resource_controller

  before_filter :authenticate_user!

  def update
    update!{ user_url }
  end

  def show
    load_object
    render :edit
  end

protected
  
  def resource
    @user ||= current_user
  end
  
end
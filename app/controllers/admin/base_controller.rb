class Admin::BaseController < ApplicationController

  include KegAdminController
  load_and_authorize_resource

  rescue_from CanCan::AccessDenied do |exception|
    render(:file => 'shared/exception', :layout => 'admin', :status => :not_found, :locals => {:alert => exception.message } )
  end

  protected

  def authenticate_admin
    authenticate_user!

    unless user_signed_in?
      flash[:error] = I18n.t("errors.messages.permission_denied")
      redirect_to root_url
    end
  end

end
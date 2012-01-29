class SessionsController < BaseController

  skip_after_filter :store_location

  def set_rpp
    session[:rpp] = params[:rpp] if params[:rpp]
    redirect_back_or_default "/"
  end
  
end
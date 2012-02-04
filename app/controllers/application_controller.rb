class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :instantiate_controller_and_action_names
  after_filter  :store_location, :only => [ :index, :show ]
  before_filter :set_locale

  def set_locale
    @locales = AppConfig[:locales].split(/[\/,]/).map(&:to_sym)
    I18n.locale = params[:locale].to_sym if @locales.include?(params[:locale].to_sym)
    I18n.locale ||= @locales.first
    @locale = I18n.locale
  end

  def store_location
    session[:return_to] = request.path
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

private

  def instantiate_controller_and_action_names
    @current_action = action_name
    @current_controller = controller_name
  end

end
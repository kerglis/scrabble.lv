class ApplicationController < ActionController::Base
  protect_from_forgery

  #respond_to :xml, :json, :html, :iphone

  after_filter  :store_location, :only => [ :index, :show ]
  before_filter :set_locale
  before_filter :adjust_format_for_iphone

  def adjust_format_for_iphone
    request.format = :iphone if iphone_request?
  end

  def iphone_request?
    p ">>>>>>>>>>>>>>>>>>"
    p request.env["HTTP_USER_AGENT"]

    request.host == "m.localhost"   ||
    request.subdomains.first == "m" || 
    (request.env["HTTP_USER_AGENT"] && request.env["HTTP_USER_AGENT"] =~ /iPhone|iPod/ )
  end

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

end
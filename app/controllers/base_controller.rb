class BaseController < ApplicationController

  layout :get_layout

  helper_method :title, :set_title
  helper_method :title, :set_title

  def get_layout
    return (params[:layout]) ? params[:layout] : "application"
  end

  def default_url_options(options={})
    { :locale => I18n.locale }
  end

  def set_title(title)
    @title = title
  end

  def title
    (@title.blank?) ? default_title : @title
  end

  def default_title
    AppConfig[:site_name]
  end

  def load_rpp
    session[:page] = params[:page] if params[:page]
    @page = session[:page]
    @page ||= 1
    @rpp = session[:rpp]
    @rpp ||= AppConfig[:rpp]
  end

  def load_filters
    name = self.class.to_s
    @filters ||= session[name]
    @filters ||= {}
    @filters
  end

  def filter
    name = self.class.to_s
    session[name] = params[:search]
    session[name] ||= {}
    redirect_back_or_default "/"
  end

  def destroy_object
    load_object
    klass = @object.class.name.underscore.to_sym
    @domid = dom_id(@object)
    @object.destroy
    respond_to do |format|
      format.html { flash[:notice] = I18n.t("resource_controller.successfully_removed"); redirect_to collection_url }
      format.js
    end
  rescue
  end

protected
  def render_404(exception = nil)
    respond_to do |type|
      type.html { render :file    => "#{RAILS_ROOT}/public/404.html", :status => "404 Not Found" }
      type.all  { render :nothing => true,              :status => "404 Not Found" }
    end
  end
end
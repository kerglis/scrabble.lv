class Admin::BaseController < BaseController
  layout :get_layout
  before_filter :authenticate_admin
  before_filter :load_rpp

  def get_layout
    return (params[:layout]) ? params[:layout] : "admin"
  end

  def swap_object
    load_object
    @object.swap
    @klass = @object.class.name.underscore.to_sym
    state = @object.state
    @flash_str = I18n.t("state_changed_to_#{state}")
    respond_to do |format|
      format.html { flash[:notice] = @flash_str; redirect_to collection_url }
      format.js
    end
  rescue
  end

  def swap_field
    load_object
    field = params[:field]
    @object[field] = !@object[field]
    @object.save(:validate => false)
    @klass = @object.class.name.underscore.to_sym
    @flash_str = I18n.t("successfully_updated")
    respond_to do |format|
      format.html { flash[:notice] = @flash_str; redirect_to collection_url }
      format.js
    end
  rescue
  end

private

  def parse_date_params
    params.each do |k, v|
      parse_date_params_for(v) if v.is_a?(Hash)
    end
  end

  def parse_date_params_for(hash)
    dates = []
    hash.each do |k, v|
      parse_date_params_for(v) if v.is_a?(Hash)
      if k =~ /\(\di\)$/
        param_name = k[/^\w+/]
        dates << param_name
      end
    end
    if (dates.size > 0)
      dates.uniq.each do |date|
        hash[date] = [hash.delete("#{date}(1i)"), hash.delete("#{date}(2i)"), hash.delete("#{date}(3i)")].join('-')
      end
    end
  end

protected
  def authenticate_admin
    authenticate_user!
    unless user_signed_in? and current_user.admin?
      flash[:error] = "Permission denied"
      redirect_to root_url
    end
  end
end
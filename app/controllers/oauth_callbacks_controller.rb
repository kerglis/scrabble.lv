class OauthCallbacksController < Devise::OmniauthCallbacksController

  before_filter :set_locale

  def set_locale
    I18n.locale = params[:locale].to_sym rescue :lv
  end

  def default_url_options(options={})
    { :locale => I18n.locale }
  end

  def facebook
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)
    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  # def failure
  #   render :text => params.inspect
  # end

  def passthru
    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end

end
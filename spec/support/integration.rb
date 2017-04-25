include Devise::TestHelpers
module HelperMethods
  # Put helper methods you need to be available in all acceptance specs here.

  def create_user(params = {})
    params[:email] ||= "demo@demo.com"
    FactoryGirl.create :user, params
  end

  def login_user(user, password = "123456")
    visit new_user_session_path
    fill_in "user_email", with: user.email
    fill_in "user_password", with: password
    click_button I18n.t("devise.sign_in")
  end

  def logout
    click_link I18n.t("devise.logout")
  end
end

RSpec.configuration.include HelperMethods, capybara_feature: true

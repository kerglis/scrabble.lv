# encoding: utf-8

require 'spec_helper'

feature 'User' do

  background do
    @user = FactoryGirl.create :user
  end

  scenario 'User shall be authorised before visiting authorizable area' do
    visit check_word_dictionary_path
    page.should have_content I18n.t("devise.failure.unauthenticated")
    page.should_not have_content I18n.t("word.check_title")

    fill_in "user_email", with: @user.email
    fill_in "user_password", with: "123456"
    click_button I18n.t("devise.sign_in")

    page.should have_content I18n.t("devise.sessions.signed_in")
    page.should have_content I18n.t("word.check_title")
  end

end
class Admin::BaseController < ApplicationController

  include KegAdminController

  include SetLocale

  before_filter :rescue_no_resource, only: [ :edit ]

private

  def rescue_no_resource
    raise ActiveRecord::RecordNotFound unless resource
  end

end
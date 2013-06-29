RSpec.configure do |config|
  config.include Warden::Test::Helpers, capybara_feature: true
  config.include Devise::TestHelpers, capybara_feature: true
end

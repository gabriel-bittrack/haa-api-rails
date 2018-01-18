OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :salesforce, ENV['SALESFORCE_APP_ID'], ENV['SALESFORCE_APP_SECRET']
end

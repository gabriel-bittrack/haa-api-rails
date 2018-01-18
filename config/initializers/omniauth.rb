OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :salesforce, '3MVG9fMtCkV6eLhfYVAy4y0Hol_9GN65OLY005nllyPjDxyH6OR4S3vKj2Y5Vkj7D.OB9FTIzxl_dRoYYnBT0
', '1510355188173771810'
end

class SyncProcessor
  def delete
  end

  def process
  end

  def client
    @client ||= Restforce.new :oauth_token => @current_user.oauth_token,
      :refresh_token => @current_user.refresh_token,
      :instance_url => @current_user.instance_url,
      :client_id => ENV['SALESFORCE_APP_ID'],
      :client_secret => ENV['SALESFORCE_APP_SECRET']
  end
end
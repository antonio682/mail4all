module AuthHelper

  # App's client ID. Register the app in Application Registration Portal to get this value.
  CLIENT_ID = ''
  # App's client secret. Register the app in Application Registration Portal to get this value.
  CLIENT_SECRET = ''

  # Scopes required by the app
  SCOPES = [ 'openid',
           'offline_access',
           'https://outlook.office.com/mail.read',
           "https://outlook.office.com/mail.send",
           'https://outlook.office.com/contacts.read']
  
  REDIRECT_URI = 'https://mail4all-antonio6822.c9users.io/api/v1/authorize' # Temporary!

  # Generates the login URL for the app.
  def get_login_url
    client = OAuth2::Client.new(CLIENT_ID,
                                CLIENT_SECRET,
                                :site => 'https://login.microsoftonline.com',
                                :authorize_url => '/common/oauth2/v2.0/authorize',
                                :token_url => '/common/oauth2/v2.0/token')
                              
    login_url = client.auth_code.authorize_url(:redirect_uri => REDIRECT_URI, :scope => SCOPES.join(' '))
  end
  
  # Exchanges an authorization code for a token
  def get_token_from_code(auth_code)
    client = OAuth2::Client.new(CLIENT_ID,
                                CLIENT_SECRET,
                                :site => 'https://login.microsoftonline.com',
                                :authorize_url => '/common/oauth2/v2.0/authorize',
                                :token_url => '/common/oauth2/v2.0/token')
  
    token = client.auth_code.get_token(auth_code,
                                       :redirect_uri => REDIRECT_URI,
                                       :scope => SCOPES.join(' '))
  end
  
  # Gets the user's email from the /Me endpoint
  def get_user_email(access_token)
    
    conn = Faraday.new(:url => 'https://outlook.office.com') do |faraday|
      # Outputs to the console
      faraday.response :logger
      # Uses the default Net::HTTP adapter
      faraday.adapter  Faraday.default_adapter  
    end
  
    response = conn.get do |request|
      # Get user's info from /Me
      request.url 'api/v2.0/Me'
      request.headers['Authorization'] = "Bearer #{access_token}"
      request.headers['Accept'] = 'application/json'
    end
    
  
    email = JSON.parse(response.body)['EmailAddress']
    
  end
  
  # Gets the current access token
  def get_access_token
    
    # Get the current token hash from session
    if session[:azure_token] == nil
      return false
    else
       token_hash = session[:azure_token]
    end

  
    client = OAuth2::Client.new(CLIENT_ID,
                                CLIENT_SECRET,
                                :site => 'https://login.microsoftonline.com',
                                :authorize_url => '/common/oauth2/v2.0/authorize',
                                :token_url => '/common/oauth2/v2.0/token')
 
    token = OAuth2::AccessToken.from_hash(client, token_hash)
  
    # Check if token is expired, refresh if so
    if token.expired?
      new_token = token.refresh!
      # Save new token
      session[:azure_token] = new_token.to_hash
      access_token = new_token.token
    else
      access_token = token.token
    end
  end
end

module AuthHelper

  # App's client ID. Register the app in Application Registration Portal to get this value.
  CLIENT_ID = ''
  # App's client secret. Register the app in Application Registration Portal to get this value.
  CLIENT_SECRET = ''

  # Scopes required by the app
  SCOPES = [ 'openid',
             'https://outlook.office.com/mail.read' ]
  
  REDIRECT_URI = 'https://mail4all-antonio6822.c9users.io' # Temporary!

  # Generates the login URL for the app.
  def get_login_url
    client = OAuth2::Client.new(CLIENT_ID,
                                CLIENT_SECRET,
                                :site => 'https://login.microsoftonline.com',
                                :authorize_url => '/common/oauth2/v2.0/authorize',
                                :token_url => '/common/oauth2/v2.0/token')
                              
    login_url = client.auth_code.authorize_url(:redirect_uri => REDIRECT_URI, :scope => SCOPES.join(' '))
  end
end

class Api::V1::AuthController < ApplicationController
    include AuthHelper
    
  def index
    login_url = get_login_url
    render :json => login_url
  end
    
  def gettoken
    token = get_token_from_code params[:code]
    session[:azure_token] = token.to_hash
    session[:user_email] = get_user_email token.token
    redirect_to api_v1_mail_inbox_url
  end
end

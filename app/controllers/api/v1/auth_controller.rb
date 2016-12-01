class Api::V1::AuthController < ApplicationController
    include AuthHelper
    
  def index
    login_url = get_login_url
   render :json => login_url
  end

end

class MailController < ApplicationController
   include AuthHelper

  def index
    token = get_access_token
    email = session[:user_email]
 
    if token
      # If a token is present in the session, get messages from the inbox
      conn = Faraday.new(:url => 'https://outlook.office.com') do |faraday|
        # Outputs to the console
        faraday.response :logger
        # Uses the default Net::HTTP adapter
        faraday.adapter  Faraday.default_adapter  
      end
 
      response = conn.get do |request|
        # Get messages from the inbox
        # Sort by ReceivedDateTime in descending orderby
        # Get the first 20 results
        request.url '/api/v2.0/Me/Messages?$orderby=ReceivedDateTime desc&$select=ReceivedDateTime,Subject,From&$top=20'
        request.headers['Authorization'] = "Bearer #{token}"
        request.headers['Accept'] = 'application/json'
        request.headers['X-AnchorMailbox'] = email
      end
      
      # Assign the resulting value to the @messages
      # variable to make it available to the view template.
      messages = JSON.parse(response.body)['value']
      render :json => messages
    else
      # If no token, redirect to the root url so user
      # can sign in.
      redirect_to root_url
    end
  end
  
  def get_contacts
    token = get_access_token
    email = session[:user_email]
    if token
      # If a token is present in the session, get messages from the inbox
      conn = Faraday.new(:url => 'https://outlook.office.com') do |faraday|
        # Outputs to the console
        faraday.response :logger
        # Uses the default Net::HTTP adapter
        faraday.adapter  Faraday.default_adapter  
      end

      response = conn.get do |request|
        # Get contacts from the default contacts folder
        # Sort by GivenName in ascending orderby
        # Get the first 10 results
        request.url '/api/v2.0/Me/Contacts?$orderby=GivenName asc&$select=GivenName,Surname,EmailAddresses&$top=10'
        request.headers['Authorization'] = "Bearer #{token}"
        request.headers['Accept'] = "application/json"
        request.headers['X-AnchorMailbox'] = email
      end

      contacts = JSON.parse(response.body)['value']
      render :json => contacts
    else
      # If no token, redirect to the root url so user
      # can sign in.
      redirect_to root_url
    end
  end
end

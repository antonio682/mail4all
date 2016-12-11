class Api::V1::MailController < ApplicationController
   include AuthHelper
   include MailHelper
   
  def inbox
    token = get_access_token
    email = session[:user_email]
 
    if token
      response = api_mail_call(token, 'https://outlook.office.com','/api/v2.0/Me/Messages?$orderby=ReceivedDateTime desc&$select=ReceivedDateTime,Subject,From&$top=20',  email)
      messages = JSON.parse(response.body)['value']
      render :json => messages
    else
      redirect_to api_v1_auth_index 
    end
  end
  
  def get_contacts
    token = get_access_token
    email = session[:user_email]
    if token
      response =  api_mail_call( token, 'https://outlook.office.com', '/api/v2.0/Me/Contacts?$orderby=GivenName asc&$select=GivenName,Surname,EmailAddresses&$top=10', email )
      contacts = JSON.parse(response.body)['value']
      render :json => contacts
    else
      redirect_to root_url
    end
  end
  
  def get_sent_items   
    token = get_access_token
    email = session[:user_email]
    if token
      response =  api_mail_call( token, 'https://outlook.office.com', '/api/v2.0/me/MailFolders/sentitems/messages/?$select=Sender,Subject', email )
      sent_items = JSON.parse(response.body)['value']      
      render :json => sent_items
    else
      redirect_to root_url
    end
  end
  
  def create_and_send_new_message(subject: "subject", content: "content", email_sender: "eric6822@gmail.com")
    token = get_access_token
    email = session[:user_email]
    
    if token                    
      request = api_mail_call_post(token, 'https://outlook.office.com/api/v2.0/me/sendmail', email,subject, content, email_sender)
        binding.pry
      response = JSON.parse(response.body)['value']
      render :json => response
    end
  end
  
  def nuevo_mensaje
  end
end

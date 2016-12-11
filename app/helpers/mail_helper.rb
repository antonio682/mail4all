module MailHelper
    def api_mail_call( token, url, request_url, email )
     conn = Faraday.new(:url => url) do |faraday|
        # Outputs to the console
        faraday.response :logger
        # Uses the default Net::HTTP adapter
        faraday.adapter  Faraday.default_adapter  
      end

      response = conn.get do |request|
        request.url request_url
        request.headers['Authorization'] = "Bearer #{token}"
        request.headers['Accept'] = "application/json"
        request.headers['X-AnchorMailbox'] = email
      end
      #binding.pry
      return response
    end
    #TODO crear mñana un modelo mensaje para las peticiones de mensajes de determinados usuarios y demas
    def api_mail_call_post( token, url, email, subject, content, email_sender)
     conn = Faraday.new(:url => url) do |faraday|
        # Outputs to the console
        faraday.response :logger
        # Uses the default Net::HTTP adapter
        faraday.adapter  Faraday.default_adapter  
      end

      response = conn.post do |request|
        request.url url
        request.headers['Authorization'] = "Bearer #{token}"
        request.headers['Accept'] = "application/json"
        request.headers['X-AnchorMailbox'] = email
        request.body = '{
                          "Message": {
                            "Subject": "#{subject}",
                            "Body": {
                              "ContentType": "Text",
                              "Content": "#{content}"
                            },
                            "ToRecipients": [
                              {
                                "EmailAddress": {
                                  "Address": "#{email_sender}"
                                }
                              }
                            ],
                            "Attachments": [
                              {
                                "@odata.type": "#Microsoft.OutlookServices.FileAttachment",
                                "Name": "menu.txt",
                                "ContentBytes": "bWFjIGFuZCBjaGVlc2UgdG9kYXk="
                              }
                            ]
                          },
                          "SaveToSentItems": "true"
                        }'
      end
      #binding.pry
      return response
    end
end

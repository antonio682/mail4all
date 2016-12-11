Rails.application.routes.draw do
  get "/" => "api/v1/mail#inbox"
  get 'crear' => 'api/v1/mail#nuevo_mensaje'
  namespace :api, defaults: { format: "json" } do
    namespace :v1 do
      #auth routes
      get 'authorize' => 'auth#gettoken'
      # mail  routes
      get 'mail/inbox' => 'mail#inbox'
      get 'mail/get_contacts' => 'mail#get_contacts'
      get 'mail/sent_items' => 'mail#get_sent_items' 
      post 'mail/send' => 'mail#create_and_send_new_message'
      get 'mail/crear' => 'mail#nuevo_mensaje'
    end
  end
end

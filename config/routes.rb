Rails.application.routes.draw do
  
  get 'mail/index'

  root 'mail#index'
  get 'authorize' => 'auth#gettoken'
  
  namespace :api, defaults: { format: "json" } do
    namespace :v1 do
      resources :auth
    end
  end
end

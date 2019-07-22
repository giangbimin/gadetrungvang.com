Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  resource :email_marketing, only: [] do
    get :send_email
  end
  resource :phu_quoc_email_marketing, only: [] do
    get :send_email
    post :bounce
  end
end

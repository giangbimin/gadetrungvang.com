Rails.application.routes.draw do

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  resource :email_marketing, only: [] do
    get :send_email
  end

  resource :phu_quoc_email_marketing, only: [] do
    get :send_email
    get :track
    post :bounce
  end

  resource :customers, only: [] do
    get :index
    collection {post :import}
  end
end

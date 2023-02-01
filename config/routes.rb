Rails.application.routes.draw do
  config = Rails.application.config.mf_hanbai_portal

  constraints host: config[:staff][:host] do
    namespace :staff, path: config[:staff][:path] do
      root "top#index"
      get "login" => "sessions#new", as: :login
      resource :session, only: [ :create, :destroy ]
      resource :account, except: [ :new, :create, :destroy ]
      resource :password, only: [ :show, :edit, :update ]
    end
  end

  constraints host: config[:admin][:host] do
    namespace :admin, path: config[:admin][:path] do
      root "top#index"
      get "login" => "sessions#new", as: :login
      resource :session, only: [ :create, :destroy ]
      resources :staff_members do
        resources :staff_events, only: [ :index ] #「誰」のログイン・ログアウト記録であるかstaff_membersから包んで特定している
      end
      resources :staff_events, only: [ :index ] #こちらは全ての職員のログイン・ログアウト記録を閲覧するためのリソース
    end
  end

  constraints host: config[:customer][:host] do
    namespace :customer, path: config[:customer][:path] do
      root "top#index"
    end
  end
end

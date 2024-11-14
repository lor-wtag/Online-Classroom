require "sidekiq/web"
Rails.application.routes.draw do
  root "home#landing_page"
  scope "(:locale)", locale: /en|be/ do
    resource :password_reset
    resources :users do
      member do
        get :delete
      end
    end
    resource :session, only: [ :new, :create, :destroy ]
    resource :password
    resources :classrooms do
      resources :enrollments do
        member do
          get :delete
        end
      end
      collection do
        get :enroll
        post :enroll, to: "classrooms#create_enrollment"
      end
      member do
        get :delete
        post :send_invitations
        get :join
      end
      resources :assignments do
        member do
          get :delete
        end
        resources :submissions do
          member do
            patch :grade
          end
        end
      end
    end
  end
  mount Rails.application.routes => "/rails/active_storage"
  mount Sidekiq::Web => "/sidekiq"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
end

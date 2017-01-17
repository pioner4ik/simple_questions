Rails.application.routes.draw do
  use_doorkeeper
  
  root to: "questions#index"

  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" }
  
  resources :users, only: [:new] do
    collection { post 'create_user_with_email' }
  end
  
  namespace :api do
    namespace :v1 do
      resources :profiles do
        get :me, on: :collection
      end
    end
  end

  concern :votable do
    member do
      post :vote
      delete :re_vote
    end
  end

  concern :commentable do
    resources :comments, only: :create, shallow: true
  end

  resources :questions , concerns: [ :votable, :commentable ] do
    resources :answers, only: [ :create, :update, :destroy], concerns: [ :votable, :commentable ], shallow: true do
      member { patch :answer_best }
    end
  end

  resources :attachments, only: :destroy

  mount ActionCable.server => '/cable'
end

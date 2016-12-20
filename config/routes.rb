Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"
  
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

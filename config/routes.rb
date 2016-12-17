Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"
  
  concern :votable do
    member do
      post :vote
      delete :re_vote
    end
  end

  resources :questions , concerns: :votable do
    resources :answers, shallow: true, concerns: :votable do
      member { patch :answer_best }
    end
  end

  resources :attachments, only: :destroy

  mount ActionCable.server => '/cable'
end

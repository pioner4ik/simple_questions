Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"
  
  resources :questions do
    member { post 'vote'}
    resources :answers, shallow: true do
      member { patch 'answer_best' }
    end
  end

  resources :attachments, only: :destroy

end

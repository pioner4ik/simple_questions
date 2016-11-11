Rails.application.routes.draw do
  resources :users

  resources :questions do
    resources :answers
  end
end

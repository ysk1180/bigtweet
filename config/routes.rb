Rails.application.routes.draw do
  get 'terms', to: 'terms#index', as: :terms
  get 'privacy', to: 'privacies#index', as: :privacy
  get '/confirm/:id', to: 'posts#confirm', as: :confirm
  resources :posts, only: [:new, :create, :show, :edit, :update]
  root to: "posts#new"
end

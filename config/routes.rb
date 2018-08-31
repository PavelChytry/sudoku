Rails.application.routes.draw do
  get 'sudokus/index'
  post 'solve', to: 'sudokus#solve', as: 'solve'

  resources :sudokus
  
  root 'sudokus#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

Rails.application.routes.draw do
  resources :question_choices
  resources :questions
  resources :quizzes
  resources :results
  get "/top_artists", to: "application#top_artists"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

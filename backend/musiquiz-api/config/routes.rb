Rails.application.routes.draw do
  resources :question_choices
  resources :questions
  resources :results
  resources :questions_quizzes
  resources :quizzes
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

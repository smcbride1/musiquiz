Rails.application.routes.draw do
  resources :question_choices

  scope "/questions" do
    post "/submit_answer", to: "questions#submit_answer"
  end
  resources :questions

  scope "/quizzes" do
    get "/generate", to: "quizzes#generate"
  end
  resources :quizzes

  resources :results
  
  get "/top_artists", to: "application#top_artists"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

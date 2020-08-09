class QuizSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :custom
  has_many :questions
end

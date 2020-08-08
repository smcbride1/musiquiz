class QuizSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :custom
  belongs_to :user
  has_many :questions
end

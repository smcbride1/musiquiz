class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :username, :email
  has_many :quizzes
  has_many :results
end

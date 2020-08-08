class QuestionChoiceSerializer
  include FastJsonapi::ObjectSerializer
  attributes :text
  belongs_to :question
end

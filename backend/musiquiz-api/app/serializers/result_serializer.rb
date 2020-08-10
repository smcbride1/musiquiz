class ResultSerializer
  include FastJsonapi::ObjectSerializer
  attributes :correct_answer_count, :total_question_count, :created_at
  belongs_to :quiz
end

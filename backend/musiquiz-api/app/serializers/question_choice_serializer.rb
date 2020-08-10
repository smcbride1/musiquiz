class QuestionChoiceSerializer
  def initialize(question_choice_object)
    @question_choice = question_choice_object
  end

  def to_serialized_json
    @question_choice.to_json(
      include: {
        question: {
          except: [:answer, :created_at, :updated_at]
        }
      }
      only: [:text]
    )
  end
end

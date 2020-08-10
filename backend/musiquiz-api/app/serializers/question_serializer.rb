class QuestionSerializer
  def initialize(question_object)
    @question = question_object
  end

  def to_serialized_json
    @question.to_json(
      include: {
        quiz: {
          except: [:updated_at]
        }, 
        question_choices: {
          only: [:text]
        }
      }, 
      except: [:answer, :created_at, :updated_at]
    )
  end
end

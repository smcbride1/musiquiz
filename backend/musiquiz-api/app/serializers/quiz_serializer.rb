class QuizSerializer
  def initialize(quiz_object)
    @quiz = quiz_object
  end

  def to_basic_serialized_json
    @quiz.to_json(
      include: {
        questions: {
          only: [:id, :artist_name]
        }
      },
      except: [:updated_at]
    )
  end

  def to_detailed_serialized_json
    @quiz.to_json(
      include: {
        questions: {
          except: [:quiz_id, :updated_at, :created_at],
          include: {
            question_choices: {
              except: [:updated_at, :created_at]
            }
          }
        }
      },
      except: [:updated_at]
    )
  end
end

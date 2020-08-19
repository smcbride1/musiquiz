class ResultSerializer
  def initialize(result_object)
    @result = result_object
  end

  def to_serialized_json
    @result.to_json(
      include: {
        quiz: {
          except: [:updated_at]
        }
      },
      except: [:quiz_id]
    )
  end
end

class QuestionsController < ApplicationController
    def index
        render json: QuestionSerializer.new(questions).to_serialized_json
    end

    def show
        render json: QuestionSerializer.new(question).to_serialized_json
    end

    def submit_answer
        Question.find(params[:id])
        
    end
    
    def questions
        Question.all
    end

    def question
        Question.find(params[:id])
    end

    def question_params
        params.require(:question).permit(
                                            :quiz_id, 
                                            :question_type, 
                                            :artist_name, 
                                            :song_name, 
                                            :youtube_url, 
                                            :start_time, 
                                            :answer
                                        )
    end
end

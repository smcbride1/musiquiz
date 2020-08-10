class QuestionsController < ApplicationController
    def index
        render json: QuestionSerializer.new(quizzes).to_serialized_json
    end

    def show
        render json: QuestionSerializer.new(quiz).to_serialized_json
    end

    def create
        render json: Question.create(question_params)
    end

    def update
        render json: Question.all
    end

    def delete
        render json: Question.all
    end

    def question
        Question.find(params[:id])
    end

    def questions
        Question.all
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

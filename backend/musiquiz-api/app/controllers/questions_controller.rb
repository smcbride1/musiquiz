class QuestionsController < ApplicationController
    def index
        render json: Question.all
    end

    def show
        render json: Question.find(params[:id])
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

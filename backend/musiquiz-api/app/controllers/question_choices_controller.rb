class QuestionChoicesController < ApplicationController
    def index
        render json: QuestionChoiceSerializer.new(question_choices).to_serialized_json
    end

    def show
        render json: QuestionChoiceSerializer.new(question_choice).to_serialized_json
    end
    
    def question_choices
        QuestionChoice.all
    end

    def question_choice
        QuestionChoice.find(params[:id])
    end
end

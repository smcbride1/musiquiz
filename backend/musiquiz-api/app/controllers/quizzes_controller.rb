class QuizzesController < ApplicationController
    def index
        render json: QuizSerializer.new(quizzes).to_basic_serialized_json
    end

    def show
        render json: QuizSerializer.new(quiz).to_detailed_serialized_json
    end

    def create
        if Quiz.create(quiz_params)
            response_status(true, "Successfully created quiz")
        else
            response_status(false, "Failed to create quiz")
        end
    end

    def destroy
        authorize?(params[:quiz_id])
        if quiz.destroy
            response_status(true, "Successfully destroyed quiz")
        else
            response_status(false, "Failed to destroy quiz")
        end
    end

    def update
        authorize?(params[:id])
        if quiz.update(quiz_params)
            response_status(true, "Successfully updated quiz")
        else
            response_status(false, "Failed to update quiz")
        end
    end
    
    def quizzes
        Quiz.all
    end

    def quiz
        Quiz.find(params[:id])
    end

    def generate
        render json: QuizSerializer.new(Quiz.generate(params[:q], params[:length])).to_detailed_serialized_json
    end

    def quiz_params
        params.require(:quiz).permit(:name)
    end
end

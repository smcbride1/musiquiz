class QuizzesController < ApplicationController
    def show
        options = {
            include: [:question]
        }
        render json: QuizSerializer.new(quiz, options)
    end

    def index
        options = {
            include: [:question]
        }
        render json: QuizSerializer.new(quizzes, options)
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
        authorize?(params[:quiz_id])
        if quiz.update(quiz_params)
            response_status(true, "Successfully updated quiz")
        else
            response_status(false, "Failed to update quiz")
        end
    end

    def quiz
        Quiz.find(params[:quiz_id])
    end

    def quizzes
        Quiz.all
    end

    def quiz_params
        params.require(:quiz).permit(:name)
    end
end

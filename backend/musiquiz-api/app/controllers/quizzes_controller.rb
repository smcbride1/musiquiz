class QuizzesController < ApplicationController
    def show
        render json: Quiz.find(params[:id])
    end

    def index
        render json: Quiz.all
    end

    def create
        Quiz.create(quizzes_params)
    end

    def delete
        Quiz.destroy(params[:id])
    end

    def quizzes_params
        params.require(:quizzes).permit(:user_id, :name, :custom)
    end
end

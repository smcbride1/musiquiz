class ResultsController < ApplicationController
    def show
        options = {
            include: [:user, :quiz]
        }
        render json: UserSerializer.new(user, options)
    end

    def index
        options = {
            include: [:user, :quiz]
        }
        render json: UserSerializer.new(users, options)
    end

    def results
        Result.all
    end
    
    def result
        Result.find(params[:id])
    end
end

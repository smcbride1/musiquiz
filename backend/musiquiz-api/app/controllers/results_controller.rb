class ResultsController < ApplicationController
    def show
        render json: ResultSerializer.new(result).to_serialized_json
    end

    def index
        render json: ResultSerializer.new(results).to_serialized_json
    end

    def create
        Result.create(result_params)
    end

    def results
        Result.all
    end
    
    def result
        Result.find(params[:id])
    end

    def result_params
        params.require(:result).permit(:quiz_id, :name, :correct_answer_count, :total_question_count)
    end
end

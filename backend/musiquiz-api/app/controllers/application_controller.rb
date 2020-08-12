class ApplicationController < ActionController::API
    def authorize?(user_id=nil)
        if params.has_key?(:user_id)
            if !session.has_key?("user_id") || params[:user_id] != session[:user_id].to_s
                return response_status(false, "You are not authorized to view this data")
            end
        else
            if helpers.current_user.id != user_id
                return response_status(false, "You are not authorized to execute this action")
            end
        end
        true
    end

    def response_status(successful, message)
        {
            successful: successful,
            message: message
        }
    end

    def top_artists
        artists = BillboardAPI.artist_100(true).sample(50)
        # artists.each do |artist|
        #     if artist[:img_url].include?("53x53")
        #         artist[:img_url] = "#{artist[:img_url].split("-53x53.jpg")[0]}.jpg"
        #     end
        # end
        render json: artists
    end
end

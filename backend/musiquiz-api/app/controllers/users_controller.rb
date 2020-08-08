class UsersController < ApplicationController
    def show
        options = {
            include: [:name, :email, :username, :password_digest]
        }
        render json: UserSerializerUser.new(user, options)
    end

    def index
        users = User.all
        options = {
            include: [:name, :email, :username, :password_digest]
        }
        render json: UserSerializerUser.new(users, options)
    end

    def create
        if User.create(user_params)
            response_status(true, "Successfully created user")
        else
            response_status(false, "Failed to create user")
        end
    end

    def destroy
        authorize?(params[:user_id])
        if user.destroy
            response_status(true, "Successfully destroyed user")
        else
            response_status(false, "Failed to destroy user")
        end
    end

    def update
        authorize?(params[:user_id])
        if user.update(user_params)
            response_status(true, "Successfully updated user")
        else
            response_status(false, "Failed to update user")
        end
    end

    def user
        User.find(params[:user_id])
    end

    def user_params
        params.require(:user).permit(:name, :email, :username, :password_digest)
    end
end

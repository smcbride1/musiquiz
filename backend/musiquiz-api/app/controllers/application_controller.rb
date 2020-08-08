require 'billboard_api'

class ApplicationController < ActionController::API
    def top_artists
        BillboardAPI.artist_100
    end
end

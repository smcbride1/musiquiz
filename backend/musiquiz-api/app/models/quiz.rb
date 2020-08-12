class Quiz < ApplicationRecord
    has_many :questions
    #guess_the_song_title
    def self.generate(query, length)
        artist = Quiz.find_artist(query)
        songs = Quiz.find_artist_songs(artist[:artist_id]);

        quiz = Quiz.create(name: "#{artist[:title]} Quiz", custom: false)

        i = 0
        while i < length.to_i
            song = songs.sample
            #question_type_answer = {"guess_the_song_title": song_name}
            question = Question.create(
                quiz_id: quiz.id, 
                question_type: "guess_the_song_title", 
                artist_name: artist[:title], 
                song_name: song[:title], 
                itunes_artwork_url: song[:artwork_url],
                itunes_preview_url: song[:preview_url]
            )

            i2 = 0
            choice_count = 4
            answer_id = rand(choice_count)
            question.update(answer: answer_id)
            while i2 < choice_count
                if i2 == answer_id
                    song_choice = song
                    QuestionChoice.create(question_id: question.id, text: song_choice[:title])
                else
                    song_choice = songs.sample
                    while song_choice == song
                        song_choice = songs.sample
                    end
                    QuestionChoice.create(question_id: question.id, text: song_choice[:title])
                end
                i2 += 1
            end

            i += 1
        end

        quiz
    end

    def self.find_artist(artist_name)
        artist_name_encoded = CGI.escape(artist_name)
        res = JSON.parse(
            HTTP.get("https://itunes.apple.com/search?term=#{artist_name_encoded}&media=music&limit=1&entity=allArtist").to_s
            )
        {
            title: res["results"][0]["artistName"],
            artist_id: res["results"][0]["artistId"]
        }
    end

    def self.find_artist_songs(artist_id)
        res = JSON.parse(
            HTTP.get("https://itunes.apple.com/lookup?id=#{artist_id}&entity=song&limit=50").to_s
            )
        songs = res["results"][1..res["results"].length].map do |result|
            {
                title: result["trackName"],
                artwork_url: result["artworkUrl100"],
                preview_url: result["previewUrl"]
            }
        end
    end
end

# def self.find_channel(artist_name)
#     artist_name_encoded = CGI.escape(artist_name)
#     res = JSON.parse(
#         HTTP.get("https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=1&q=#{artist_name_encoded}&topicId=%2Fm%2F04rlf&type=channel&key=#{ENV['YOUTUBE_KEY']}").to_s
#         )
#     {
#         title: res["items"][0]["snippet"]["title"].include?(" - Topic") ? res["items"][0]["snippet"]["title"].split(" - Topic")[0] : res["items"][0]["snippet"]["title"],
#         id: res["items"][0]["id"]["channelId"]
#     }
# end

# def self.get_channel_videos(channel_id)
#     res = JSON.parse(
#         HTTP.get("https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=50&channelId=#{channel_id}&topicId=%2Fm%2F04rlf&type=video&key=#{ENV['YOUTUBE_KEY']}").to_s
#         )
#     video_id = res["items"].sample["id"]["videoId"]
#     videos = res["items"].map do |item|
#         {
#             title: item["snippet"]["title"],
#             id: item["id"]["videoId"]
#         }
#     end
# end

# def self.get_video_info(video_id)
#     res = JSON.parse(
#         HTTP.get("https://www.googleapis.com/youtube/v3/videos?part=contentDetails&id=#{video_id}&key=#{ENV['YOUTUBE_KEY']}").to_s
#         )
#     {
#         video_id: res["items"][0]["id"],
#         duration: Quiz.duration_string_to_seconds(res["items"][0]["contentDetails"]["duration"])
#     }
# end

# def self.duration_string_to_seconds(duration_string)
#     duration_seconds = 0
#     duration_string = duration_string.split("PT")[1]
    
#     if duration_string.include?("H")
#         duration_seconds += duration_string.split("H")[0].to_i * 360
#         duration_string = duration_string.split("H")[1]
#     end

#     if duration_string.include?("M")
#         duration_seconds += duration_string.split("M")[0].to_i * 60
#         duration_string = duration_string.split("M")[1]
#     end
#     duration_seconds += duration_string.split("S")[0].to_i
#     duration_string = duration_string.split("S")[1]

#     duration_seconds
# end

# def self.get_random_start_time(duration_seconds, offset)
#     rand(duration_seconds - offset)
# end
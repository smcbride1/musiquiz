class Quiz < ApplicationRecord
    has_many :questions
    def self.generate(query, length)
        if query
            channel = Quiz.find_channel(query)
            videos = Quiz.get_channel_videos(channel[:id])

            quiz = Quiz.create(name: "#{channel[:title]} Quiz", custom: false)

            i = 0
            while i < length.to_i
                video = videos.sample
                video_info = Quiz.get_video_info(video[:id])

                question = Question.create(
                    quiz_id: quiz.id, 
                    question_type: "guess_the_song_title", 
                    artist_name: channel[:title], 
                    song_name: video[:title], 
                    youtube_video_id: video[:id], 
                    start_time: Quiz.get_random_start_time(video_info[:duration], 30)
                )

                i2 = 0
                choice_count = 4
                answer_id = rand(choice_count)
                while i2 < choice_count
                    if i2 == answer_id
                        video_choice = video
                        QuestionChoice.create(question_id: question.id, text: video_choice[:title])
                    else
                        video_choice = videos.sample
                        while video_choice == video
                            video_choice = videos.sample
                        end
                        QuestionChoice.create(question_id: question.id, text: video_choice[:title])
                    end
                    i2 += 1
                end

                i += 1
            end

            quiz
        else
            BillboardAPI.artist_100.sample
        end
    end

    def self.find_channel(artist_name)
        res = JSON.parse(
            HTTP.get("https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=1&q=#{artist_name}&topicId=%2Fm%2F04rlf&type=channel&key=#{ENV['YOUTUBE_KEY']}").to_s
            )
        {
            title: res["items"][0]["snippet"]["title"].include?(" - Topic") ? res["items"][0]["snippet"]["title"].split(" - Topic")[0] : res["items"][0]["snippet"]["title"],
            id: res["items"][0]["id"]["channelId"]
        }
    end

    def self.get_channel_videos(channel_id)
        res = JSON.parse(
            HTTP.get("https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=50&channelId=#{channel_id}&topicId=%2Fm%2F04rlf&type=video&key=#{ENV['YOUTUBE_KEY']}").to_s
            )
        video_id = res["items"].sample["id"]["videoId"]
        videos = res["items"].map do |item|
            {
                title: item["snippet"]["title"],
                id: item["id"]["videoId"]
            }
        end
    end

    def self.get_video_info(video_id)
        res = JSON.parse(
            HTTP.get("https://www.googleapis.com/youtube/v3/videos?part=contentDetails&id=#{video_id}&key=#{ENV['YOUTUBE_KEY']}").to_s
            )
        {
            video_id: res["items"][0]["id"],
            duration: Quiz.duration_string_to_seconds(res["items"][0]["contentDetails"]["duration"])
        }
    end

    def self.duration_string_to_seconds(duration_string)
        duration_seconds = 0
        duration_string = duration_string.split("PT")[1]
        
        if duration_string.include?("H")
            duration_seconds += duration_string.split("H")[0].to_i * 360
            duration_string = duration_string.split("H")[1]
        end

        if duration_string.include?("M")
            duration_seconds += duration_string.split("M")[0].to_i * 60
            duration_string = duration_string.split("M")[1]
        end
        byebug
        duration_seconds += duration_string.split("S")[0].to_i
        duration_string = duration_string.split("S")[1]

        duration_seconds
    end

    def self.get_random_start_time(duration_seconds, offset)
        rand(duration_seconds - offset)
    end
end

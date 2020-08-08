class QuestionSerializer
  include FastJsonapi::ObjectSerializer
  attributes :question_type, :artist_name, :song_name, :youtube_url, :start_time
  belongs_to :quiz
  has_many :question_choices
end

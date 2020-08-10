# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Quiz.find_or_create_by(name: "Shakewell Quiz", custom: false)

Question.find_or_create_by(quiz_id: 1, question_type: "artist_song", artist_name: "Shakewell", song_name: "Late Night", youtube_video_id: "https://www.youtube.com/watch?v=JknIs_S4eEo", start_time: 38, answer: 2)

QuestionChoice.find_or_create_by(question_id: 1, text: "Leglock")
QuestionChoice.find_or_create_by(question_id: 1, text: "Late Night")
QuestionChoice.find_or_create_by(question_id: 1, text: "Pemex")
QuestionChoice.find_or_create_by(question_id: 1, text: "Way Back")
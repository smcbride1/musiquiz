class CreateQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :questions do |t|
      t.integer :quiz_id
      t.string :question_type
      t.string :artist_name
      t.string :song_name
      t.string :youtube_url
      t.integer :start_time
      t.integer :answer

      t.timestamps
    end
  end
end

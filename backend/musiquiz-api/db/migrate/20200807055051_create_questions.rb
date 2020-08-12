class CreateQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :questions do |t|
      t.integer :quiz_id
      t.string :question_type
      t.string :artist_name
      t.string :song_name
      t.string :itunes_artwork_url
      t.string :itunes_preview_url
      t.integer :answer

      t.timestamps
    end
  end
end

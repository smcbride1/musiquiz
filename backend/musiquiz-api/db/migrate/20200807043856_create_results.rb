class CreateResults < ActiveRecord::Migration[6.0]
  def change
    create_table :results do |t|
      t.integer :quiz_id
      t.integer :correct_answer_count
      t.integer :total_question_count

      t.timestamps
    end
  end
end

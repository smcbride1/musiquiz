class CreateQuestionsQuizzes < ActiveRecord::Migration[6.0]
  def change
    create_table :questions_quizzes do |t|
      t.integer :question_id
      t.integer :quiz_id

      t.timestamps
    end
  end
end

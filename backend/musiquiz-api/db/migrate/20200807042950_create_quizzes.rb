class CreateQuizzes < ActiveRecord::Migration[6.0]
  def change
    create_table :quizzes do |t|
      t.string :name
      t.boolean :custom

      t.timestamps
    end
  end
end

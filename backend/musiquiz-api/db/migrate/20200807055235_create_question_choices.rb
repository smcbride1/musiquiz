class CreateQuestionChoices < ActiveRecord::Migration[6.0]
  def change
    create_table :question_choices do |t|
      t.string :text

      t.timestamps
    end
  end
end

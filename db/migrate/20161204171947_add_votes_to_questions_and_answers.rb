class AddVotesToQuestionsAndAnswers < ActiveRecord::Migration[5.0]
  def change
    add_column :votes, :user_id, :integer
    add_column :votes, :vote_type_id, :integer
    add_column :votes, :vote_type_type, :integer

    add_index :votes, :user_id
    add_index :votes, :vote_type_id
    add_index :votes, :vote_type_type
  end
end

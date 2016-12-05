class RenameColumnVoteType < ActiveRecord::Migration[5.0]
  def change
    remove_index :votes, :vote_type_id
    remove_index :votes, :vote_type_type
    remove_column :votes, :vote_type_type

    rename_column :votes, :vote_type_id, :votable_id

    add_column :votes, :votable_type, :string

    add_index :votes, :votable_id
    add_index :votes, :votable_type
  end
end

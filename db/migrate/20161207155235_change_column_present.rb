class ChangeColumnPresent < ActiveRecord::Migration[5.0]
  def change
    remove_column :votes, :present
    add_column :votes, :value, :integer
  end
end

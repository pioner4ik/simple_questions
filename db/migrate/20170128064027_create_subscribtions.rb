class CreateSubscribtions < ActiveRecord::Migration[5.0]
  def change
    create_table :subscribtions do |t|
      t.references :user, foreign_key: true, index: true
      t.references :question, foreign_key: true, index: true
      t.timestamps
    end
  end
end

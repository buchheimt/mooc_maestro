class DropGoalFromUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :goal
  end
end

class AddCreatorIdColumns < ActiveRecord::Migration[5.1]
  def change
    add_column :programs, :creator_id, :integer
    add_column :platforms, :creator_id, :integer
    add_column :subjects, :creator_id, :integer
  end
end

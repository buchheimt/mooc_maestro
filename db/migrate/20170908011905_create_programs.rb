class CreatePrograms < ActiveRecord::Migration[5.1]
  def change
    create_table :programs do |t|
      t.string :name
      t.string :certification
      t.float :cost
      t.integer :platform_id
      t.string :affiliation
    end
  end
end

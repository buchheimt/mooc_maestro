class CreatePrograms < ActiveRecord::Migration[5.1]
  def change
    create_table :programs do |t|
      t.string :name
      t.string :description
      t.string :certification
      t.float :cost
      t.string :affiliation
      t.integer :platform_id
    end
  end
end

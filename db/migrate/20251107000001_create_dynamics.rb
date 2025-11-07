class CreateDynamics < ActiveRecord::Migration[7.2]
  def change
    create_table :dynamics do |t|
      t.string :name, null: false
      t.text :objective, null: false
      t.text :description

      t.timestamps
    end
  end
end

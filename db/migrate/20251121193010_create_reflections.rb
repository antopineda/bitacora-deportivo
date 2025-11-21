class CreateReflections < ActiveRecord::Migration[7.2]
  def change
    create_table :reflections do |t|
      t.string :name, null: false
      t.text :reflection, null: false

      t.timestamps
    end
  end
end

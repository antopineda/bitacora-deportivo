class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.string :name, null: false
      t.string :objective, null: false
      t.text :description

      t.timestamps
    end
  end
end

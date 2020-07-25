class CreateChests < ActiveRecord::Migration[6.0]
  def change
    create_table :chests do |t|
      t.integer :player_id
      t.decimal :cost
      t.decimal :reward

      t.timestamps
    end
  end
end

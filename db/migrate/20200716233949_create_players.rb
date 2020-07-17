class CreatePlayers < ActiveRecord::Migration[6.0]
  def change
    create_table :players do |t|
      t.string :deposit_address
      t.string :cashout_address

      t.timestamps
    end
  end
end

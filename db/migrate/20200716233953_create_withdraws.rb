class CreateWithdraws < ActiveRecord::Migration[6.0]
  def change
    create_table :withdraws do |t|
      t.references :player, null: false, foreign_key: true
      t.decimal :amount

      t.timestamps
    end
  end
end

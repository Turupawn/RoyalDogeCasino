class CreateCasinos < ActiveRecord::Migration[6.0]
  def change
    create_table :casinos do |t|

      t.timestamps
    end
  end
end

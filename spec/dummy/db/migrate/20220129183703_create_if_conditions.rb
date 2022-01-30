class CreateIfConditions < ActiveRecord::Migration[5.2]
  def change
    create_table :if_conditions do |t|
      t.string "example"

      t.timestamps
    end
  end
end

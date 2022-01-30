class CreateAllCallbacks < ActiveRecord::Migration[5.2]
  def change
    create_table :all_callbacks do |t|
      t.string :example

      t.timestamps
    end
  end
end

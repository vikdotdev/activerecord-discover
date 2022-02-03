class CreateSimple < ActiveRecord::Migration[5.2]
  def change
    create_table :simple do |t|
      t.string :example

      t.timestamps
    end
  end
end

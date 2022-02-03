class CreateWithOptions < ActiveRecord::Migration[6.1]
  def change
    create_table :with_options do |t|
      t.string :example

      t.timestamps
    end
  end
end

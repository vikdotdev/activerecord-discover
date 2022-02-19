class CreateAlpha < ActiveRecord::Migration[5.2]
  def change
    create_table :alpha do |t|
      t.timestamps
    end
  end
end

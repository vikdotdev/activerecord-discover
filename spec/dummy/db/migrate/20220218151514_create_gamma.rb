class CreateGamma < ActiveRecord::Migration[6.1]
  def change
    create_table :gamma do |t|
      t.timestamps
    end
  end
end

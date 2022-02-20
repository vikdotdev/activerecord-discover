class CreateEta < ActiveRecord::Migration[6.1]
  def change
    create_table :eta do |t|

      t.timestamps
    end
  end
end

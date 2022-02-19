class CreateIota < ActiveRecord::Migration[6.1]
  def change
    create_table :iota do |t|

      t.timestamps
    end
  end
end

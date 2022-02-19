class CreateNoCallbacks < ActiveRecord::Migration[6.1]
  def change
    create_table :no_callbacks do |t|

      t.timestamps
    end
  end
end

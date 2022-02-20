class CreateTheta < ActiveRecord::Migration[6.1]
  def change
    create_table :theta do |t|

      t.timestamps
    end
  end
end

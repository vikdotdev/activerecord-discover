class CreateZeta < ActiveRecord::Migration[6.1]
  def change
    create_table :zeta do |t|

      t.timestamps
    end
  end
end

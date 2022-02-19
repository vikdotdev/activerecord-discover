class CreateBeta < ActiveRecord::Migration[6.1]
  def change
    create_table :beta do |t|
      t.timestamps
    end
  end
end

class CreateCars < ActiveRecord::Migration
  def change
    create_table :cars do |t|
      t.string :description
      t.float :latitude
      t.float :longitude

      t.timestamps null: false
    end
  end
end

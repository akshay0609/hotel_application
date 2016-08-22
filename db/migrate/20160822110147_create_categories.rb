class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :category_type
      t.string :facility
      t.integer :price
      t.timestamps
    end
  end
end

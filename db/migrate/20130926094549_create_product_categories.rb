class CreateProductCategories < ActiveRecord::Migration
  def change
    create_table :shoppe_product_categories do |t|
      t.string :name, :permalink
      t.text :description
      t.timestamps
    end
  end
end

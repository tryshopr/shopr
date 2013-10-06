class AddBoxFieldsToProducts < ActiveRecord::Migration
  def change
    add_column :shoppe_products, :in_the_box, :text
  end
end
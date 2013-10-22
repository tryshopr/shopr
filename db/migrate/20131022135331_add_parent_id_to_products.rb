class AddParentIdToProducts < ActiveRecord::Migration
  def change
    add_column :shoppe_products, :parent_id, :integer, :after => :id
  end
end
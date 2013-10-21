class AddNotesToOrders < ActiveRecord::Migration
  def change
    add_column :shoppe_orders, :notes, :text
  end
end
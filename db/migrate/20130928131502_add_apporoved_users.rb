class AddApporovedUsers < ActiveRecord::Migration
  def change
    add_column :shoppe_orders, :approved_by, :integer, :after => :approved_at
    add_column :shoppe_orders, :shipped_by, :integer, :after => :shipped_at
    add_column :shoppe_orders, :consignment_number, :string
  end
end
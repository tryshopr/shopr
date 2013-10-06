class AddRejectionToOrders < ActiveRecord::Migration
  def change
    add_column :shoppe_orders, :rejected_at, :datetime, :after => :approved_by
    add_column :shoppe_orders, :rejected_by, :integer, :after => :rejected_at
  end
end
class CreateShoppePayments < ActiveRecord::Migration
  def up
    create_table :shoppe_payments do |t|
      t.integer :order_id
      t.decimal :amount, :precision => 8, :scale => 2
      t.string :reference, :method
      t.boolean :exported, :default => false
      t.timestamps
    end
    remove_column :shoppe_orders, :paid_at
    remove_column :shoppe_orders, :payment_reference
    remove_column :shoppe_orders, :payment_method
    
    add_column :shoppe_orders, :exported, :boolean, :default => false
  end
  
  def down
    drop_table :shoppe_payments
    add_column :shoppe_orders, :paid_at, :datetime
    add_column :shoppe_orders, :payment_reference, :string
    add_column :shoppe_orders, :payment_method, :string
    remove_column :shoppe_orders, :exported
  end
end
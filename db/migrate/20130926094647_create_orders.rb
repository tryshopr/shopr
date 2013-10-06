class CreateOrders < ActiveRecord::Migration
  def change
    create_table :shoppe_orders do |t|

      t.string :token
      
      # address details
      t.string :first_name, :last_name, :company, :address1, :address2, :address3, :address4, :postcode
      t.string :email_address, :phone_number
      
      # statuses
      t.string :status # building, received, approved, shipped
      t.datetime :received_at
      t.datetime :approved_at
      t.datetime :shipped_at
      
      t.timestamps
    end
  end
end

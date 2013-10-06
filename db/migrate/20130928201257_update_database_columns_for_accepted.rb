class UpdateDatabaseColumnsForAccepted < ActiveRecord::Migration
  def change
    rename_column :shoppe_orders, :approved_at, :accepted_at
    rename_column :shoppe_orders, :approved_by, :accepted_by
  end
end
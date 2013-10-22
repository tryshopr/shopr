class RenameProductTitleToName < ActiveRecord::Migration
  def change
    rename_column :shoppe_products, :title, :name
  end
end
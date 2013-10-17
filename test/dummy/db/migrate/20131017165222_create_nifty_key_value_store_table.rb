class CreateNiftyKeyValueStoreTable < ActiveRecord::Migration
  
  def up
    create_table :nifty_key_value_store do |t|
      t.integer :parent_id
      t.string  :parent_type, :group, :name, :value
    end
  end
  
  def down
    drop_table :nifty_key_value_store
  end
  
end
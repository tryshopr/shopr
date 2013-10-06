class CreateImages < ActiveRecord::Migration
  def change
    create_table :shoppe_attachments do |t|
      t.integer :parent_id
      t.string :parent_type, :token

      t.string :role
      t.string :file_name
      t.string :file_type
      t.binary :data, :limit => 10.megabytes

      t.timestamps
    end
  end
end

class CreateShoppeProductTranslationTable < ActiveRecord::Migration
  def up
    Shoppe::Product.create_translation_table! :name => :string, :permalink => :string, :description => :text, :short_description => :text
  end
  def down
    Shoppe::Product.drop_translation_table!
  end
end

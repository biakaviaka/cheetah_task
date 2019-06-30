class CreateTablePosts < Sequel::Migration
  def up
    create_table :products do
      primary_key :id
      column :product_name, :text
      column :photo_url, :text
      column :barcode, :text
      column :price_cents, :text
      column :sku_unique_id, :integer
      column :producer, :text
      index :sku_unique_id
    end
  end

  def down
    drop_table :products
  end
end

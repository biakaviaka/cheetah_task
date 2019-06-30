class Product < Sequel::Model(DB)

  def self.get_products_by_producer(producer, page)
    puts clean_string(producer)
    puts page
    db_products = DB[:products].where(producer: clean_string(producer)).limit(PRODUCTS_PER_PAGE).offset(PRODUCTS_PER_PAGE * (page.to_i - 1))
    hashes = db_products.collect { |row|
      row.to_hash
    }

    JSON.generate(hashes)
  end

  def insert_or_update
    products = DB[:products]
    db_product = products.where(sku_unique_id: self.sku_unique_id).first
    response = {action: '', amount: 0, success: false}

    if db_product.nil?
      response[:action] = 'inserted'
      begin
        products.insert(
          product_name: self.product_name,
          photo_url: self.photo_url,
          barcode: self.barcode,
          price_cents: self.price_cents,
          producer: clean_string(self.producer),
          sku_unique_id: self.sku_unique_id
        )
        response[:amount] = 1
        response[:success] = true
      rescue Sequel::Error => e
        p e.message
      end
    else
      response[:action] = 'updated'
      begin
        puts clean_string(self.producer)
        amount = products.where(sku_unique_id: self.sku_unique_id).update(
          product_name: self.product_name,
          photo_url: self.photo_url,
          barcode: self.barcode,
          price_cents: self.price_cents,
          producer: clean_string(self.producer)
        )
        response[:amount] = amount
        response[:success] = true
      rescue Sequel::Error => e
        p e.message
      end
    end
    response
  end
end

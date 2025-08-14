class CreateListings < ActiveRecord::Migration[8.0]
  def change
    create_table :listings do |t|
      t.string :address, null: false
      t.string :city, null: false
      t.string :state, null: false
      t.string :zip_code
      t.decimal :price, precision: 12, scale: 2
      t.integer :bedrooms
      t.integer :bathrooms
      t.integer :square_feet
      t.text :description
      t.text :images  # Will be serialized as Array
      t.string :source  # Which API the listing came from
      t.string :property_type
      t.integer :year_built
      t.integer :lot_size
      t.date :listing_date
      t.string :external_id  # ID from the source API
      t.jsonb :raw_data  # Store original API response
      t.boolean :active, default: true

      t.timestamps
    end

    # Add indexes for better query performance
    add_index :listings, :city
    add_index :listings, :state
    add_index :listings, :price
    add_index :listings, :bedrooms
    add_index :listings, :bathrooms
    add_index :listings, :source
    add_index :listings, :external_id
    add_index :listings, :active
    add_index :listings, [:city, :state]
    add_index :listings, [:price, :bedrooms, :bathrooms]
  end
end 
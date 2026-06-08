class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name
      t.string :slug
      t.text :description
      t.integer :base_price_cents
      t.boolean :active
      t.boolean :featured
      t.references :category, null: false, foreign_key: true
      t.references :section, null: false, foreign_key: true

      t.timestamps
    end
  end
end

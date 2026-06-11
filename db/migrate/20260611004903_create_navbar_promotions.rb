class CreateNavbarPromotions < ActiveRecord::Migration[7.1]
  def change
    create_table :navbar_promotions do |t|
      t.string :text
      t.string :link_url
      t.boolean :active
      t.integer :position

      t.timestamps
    end
  end
end

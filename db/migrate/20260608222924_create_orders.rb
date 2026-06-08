class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.references :address, null: false, foreign_key: true
      t.string :status
      t.string :payment_status
      t.integer :subtotal_cents
      t.integer :shipping_cents
      t.integer :total_cents

      t.timestamps
    end
  end
end

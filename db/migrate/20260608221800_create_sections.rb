class CreateSections < ActiveRecord::Migration[7.1]
  def change
    create_table :sections do |t|
      t.string :name
      t.string :slug
      t.integer :position
      t.boolean :active

      t.timestamps
    end
  end
end

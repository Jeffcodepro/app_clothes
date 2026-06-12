class AddOmniauthToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :provider, :string unless column_exists?(:users, :provider)
    add_column :users, :uid, :string unless column_exists?(:users, :uid)
    add_column :users, :avatar_url, :string unless column_exists?(:users, :avatar_url)

    unless index_exists?(:users, [:provider, :uid])
      add_index :users, [:provider, :uid], unique: true
    end
  end
end

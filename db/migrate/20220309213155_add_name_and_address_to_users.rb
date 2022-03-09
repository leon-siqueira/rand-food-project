class AddNameAndAddressToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :name, :string, default: "", null: false
    add_column :users, :address, :string, default: "", null: false
  end
end

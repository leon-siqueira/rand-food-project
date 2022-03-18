class AddTastesMoods < ActiveRecord::Migration[6.1]
  def change
    add_column :moods, :tastes, :string, default: "", null: false
  end
end

class AddTastesMoods < ActiveRecord::Migration[6.1]
  def change
    add_column :moods, :tastes, :text, array: true, default: []
  end
end

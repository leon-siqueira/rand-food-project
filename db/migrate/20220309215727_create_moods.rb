class CreateMoods < ActiveRecord::Migration[6.1]
  def change
    create_table :moods do |t|
      t.string :name, null: false, default: ""
      t.string :query, null: false, default: ""
      t.string :near, null: false, default: ""
      t.integer :min_price, null: false, default: 1
      t.integer :max_price, null: false, default: 4
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end

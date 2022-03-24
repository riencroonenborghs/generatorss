class CreateFilters < ActiveRecord::Migration[7.0]
  def change
    create_table :filters do |t|
      t.references :user, null: false, foreign_key: true
      t.string :comparison
      t.string :value

      t.timestamps
    end
  end
end

class CreateSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :subscriptions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :subscriptable, polymorphic: true, null: false
      t.text :uuid, null: false

      t.timestamps
    end
  end
end

class CreateTwitterUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :twitter_users do |t|
      t.datetime :last_loaded
      t.string :twitter_id, null: false
      t.string :name, null: false
      t.string :username, null: false
      t.string :description
      t.string :profile_image_url
      t.string :url
      t.boolean :verified, null: false, default: false

      t.timestamps
    end

    add_index :twitter_users, :twitter_id
  end
end

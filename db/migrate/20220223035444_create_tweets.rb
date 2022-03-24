class CreateTweets < ActiveRecord::Migration[7.0]
  def change
    create_table :tweets do |t|
      t.references :twitter_user, null: false, foreign_key: true
      t.string :tweet_id, null: false
      t.text :text, null: false
      t.text :title, null: false
      t.datetime :tweeted_at, null: false
      t.string :source

      t.timestamps
    end

    add_index :tweets, :tweeted_at
    add_index :tweets, :tweet_id
  end
end

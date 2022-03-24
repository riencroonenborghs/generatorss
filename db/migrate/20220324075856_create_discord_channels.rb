class CreateDiscordChannels < ActiveRecord::Migration[7.0]
  def change
    create_table :discord_channels do |t|
      t.string :channel_id, null: false
      t.string :guild_id, null: false
      t.string :name, null: false
      t.string :description
      t.datetime :last_loaded

      t.timestamps
    end
    add_index :discord_channels, :channel_id
    add_index :discord_channels, :last_loaded
  end
end

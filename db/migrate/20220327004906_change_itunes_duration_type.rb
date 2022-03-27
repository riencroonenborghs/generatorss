class ChangeItunesDurationType < ActiveRecord::Migration[7.0]
  def up
    change_column :rss_items, :itunes_duration, :string
  end

  def down
    change_column :rss_items, :itunes_duration, :integer
  end
end

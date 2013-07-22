class AddCrawledToLinks < ActiveRecord::Migration
  def change
    add_column :links, :crawled, :boolean
  end
end

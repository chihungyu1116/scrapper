class AddColumnCompletedToMerchants < ActiveRecord::Migration
  def change
  	add_column :merchants, :completed, :boolean
  end
end

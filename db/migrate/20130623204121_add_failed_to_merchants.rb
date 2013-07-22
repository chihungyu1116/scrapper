class AddFailedToMerchants < ActiveRecord::Migration
  def change
  	add_column :merchants, :failed, :boolean
  end
end

class AddMerchantIdToLinks < ActiveRecord::Migration
  def change
    add_column :links, :merchant_id, :integer
  end
end

class AddLatLonToMerchants < ActiveRecord::Migration
  def change
  	add_column :merchants, :latlon, :string
  end
end
class ChangeWifiTypeToMerchants < ActiveRecord::Migration
  def change
  	change_column :merchants, :wifi, :string
  	# change_column :merchants, :allow_dog, :string
  	# change_column :merchants, :catering, :string
  	# change_column :merchants, :has_tv, :string
  	# change_column :merchants, :good_for_dancing, :string
  	# change_column :merchants, :alcohol, :string
  	# change_column :merchants, :wheelchair_accessible, :string
  	# change_column :merchants, :good_for_group, :string
  	# change_column :merchants, :good_for_kids, :string
  	# change_column :merchants, :accept_credit_card, :string
  	# change_column :merchants, :take_reservation, :string
  	# change_column :merchants, :delivery, :string
  	# change_column :merchants, :takeout, :string
  	# change_column :merchants, :waiter_service, :string
  	# change_column :merchants, :happy_hours, :string
  	# change_column :merchants, :smoking, :string
  	# change_column :merchants, :coat_check, :string
  	# change_column :merchants, :outdoor_seating, :string
  end
end

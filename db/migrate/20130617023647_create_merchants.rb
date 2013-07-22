class CreateMerchants < ActiveRecord::Migration
  def change
    create_table :merchants do |t|
		t.string :name
		t.string :address
		t.string :city
		t.string :state
		t.string :zip
		t.string :category
		t.string :phone
		t.string :website
		t.string :parking
		t.string :attire
		t.string :good_for_meal # breakfast, lunch, dinner
		t.string :hours # http://www.yelp.com/biz/lazy-bear-san-francisco # may have multiple hours
		t.string :music # http://www.yelp.com/biz/old-skool-cafe-san-francisco
		t.string :best_nights # Thur, Fri, Sat, http://www.yelp.com/biz/old-skool-cafe-san-francisco
		t.string :noise_level # http://www.yelp.com/biz/old-skool-cafe-san-francisco
		t.string :ambience # http://www.yelp.com/biz/old-skool-cafe-san-francisco


		t.float :price_range
		t.float :rating

		t.integer :health_score # http://www.yelp.com/biz/old-skool-cafe-san-francisco # http://www.yelp.com/biz/yasukochis-sweet-stop-san-francisco

		t.boolean :wifi # http://www.yelp.com/biz/lazy-bear-san-francisco
		t.boolean :allow_dog # http://www.yelp.com/biz/old-skool-cafe-san-francisco
		t.boolean :catering # http://www.yelp.com/biz/old-skool-cafe-san-francisco
		t.boolean :has_tv # http://www.yelp.com/biz/old-skool-cafe-san-francisco
		t.boolean :good_for_dancing # http://www.yelp.com/biz/old-skool-cafe-san-francisco
		t.boolean :alcohol
		t.boolean :wheelchair_accessible
		t.boolean :good_for_group
		t.boolean :good_for_kids
		t.boolean :accept_credit_card
     	t.boolean :take_reservation
     	t.boolean :delivery
     	t.boolean :takeout
     	t.boolean :waiter_service # http://www.yelp.com/biz/rockys-fry-bread-san-francisco
     	t.boolean :happy_hours # http://www.yelp.com/biz/old-skool-cafe-san-francisco
     	t.boolean :smoking # http://www.yelp.com/biz/old-skool-cafe-san-francisco
     	t.boolean :coat_check # http://www.yelp.com/biz/old-skool-cafe-san-francisco
     	t.boolean :outdoor_seating # http://www.yelp.com/biz/pie-tisserie-oakland

     	t.text :reviews
     	t.text :html
      	t.timestamps
    end
  end
end

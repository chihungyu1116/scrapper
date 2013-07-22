class AdminController < ApplicationController
	include AdminHelper



	def home
	end

	def update
		if params[:trip_advisor]
			scrap_trip_advisor
		elsif params[:yelp]
			scrap_yelp
		end

		redirect_to '/'
	end
end

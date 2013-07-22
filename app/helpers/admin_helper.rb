module AdminHelper
	require 'rubygems'
	require 'nokogiri'
	require 'rexml/document'
	require 'cgi'
	require 'open-uri'

	# save the very first link to the database
	# query database to see available unvisited links
	# if link is target of interest, collect info
	# collect links on the page and save to the database if its not already there, and set domain to (yelp/trip_advisor)
	# mark link as visited

	# if link open unsuccessfully try 2 more times if failed mark as failed
	# if link get redirected to non-targeted domain stop...

	def scrap_yelp
		#admin_visit_links_2('yelp')
		admin_get_html_from_link('yelp') #[!!!]
		#admin_remove_tab_newline_from_html
		#admin_parse_merchant_from_html('yelp')
		#admin_get_latlon_from_address
	end


	def admin_get_latlon_from_address
		all = Merchant.all

		merchants = []

		all.each do |m|
			if m[:latlon].blank?
				merchants << m
				Rails.logger.info "#{m[:id]} #{m[:latlon]}"
				break if merchants.size > 2450
			end
		end

		merchants.each_with_index do |merchant, index|
			address = merchant[:address]
			city = merchant[:city]
			state = merchant[:state]
			zip = merchant[:zip]

			address = '' if address.blank?
			city = city.blank? ? '' : ", #{city}" 
			state = state.blank? ? '' : ", #{state}"
			zip = zip.blank? ? '' : " #{zip}"

			full_address = "#{address}, #{city}, #{state} #{zip}"

			sleep 0.5

			result = Geocoder.search(full_address)

			if result.blank?
				latlon = ''
			else
				lat = result[0].latitude.to_s
				lon = result[0].longitude.to_s
				latlon = "#{lat},#{lon}"
			end

			merchant.update_attributes(:latlon => latlon)
		end
	end

	def admin_remove_tab_newline_from_html
		merchants = Merchant.where(completed:true)
		#103.66gb

		merchants.each_with_index do |merchant, index|
			Rails.logger.info "start ------ #{index}"
			html = merchant[:html]
			html = admin_strip_text(html)
			merchant.update_attributes(html:html)
			Rails.logger.info "done ------ #{index}"
		end
	end

	def admin_parse_merchant_from_html(type)
		merchants = Merchant.where(completed:nil, failed:nil)
	
		merchants.each do |merchant|
			html = merchant[:html]

			noko = Nokogiri::HTML(html)

			begin #1
				name = noko.css('#bizInfoHeader h1[itemprop=name]')[0].text
				name = admin_strip_text(name)
			rescue
				name = ""
			end

			begin #2
				address = noko.css('address span[itemprop=streetAddress]')[0].text
				address = admin_strip_text(address)
			rescue
				address = ""
			end

			begin #3
				city = noko.css('address span[itemprop=addressLocality]')[0].text
				city = admin_strip_text(city)
			rescue
				city = ""
			end

			begin #4
				state = noko.css('address span[itemprop=addressRegion]')[0].text
				state = admin_strip_text(state)
			rescue
				state = ""
			end

			begin #5
				zip = noko.css('address span[itemprop=postalCode]')[0].text
				zip = admin_strip_text(zip)
			rescue
				zip = ""
			end

			begin #6
				categories = []
				noko.css('#cat_display a').each do |category|
					categories.push category.text
				end
				categories = categories.join(',')
				categories = admin_strip_text(categories)
			rescue
				categories = ""
			end

			begin #7
				phone = noko.css('#bizPhone')[0].text
				phone = admin_strip_text(phone)
			rescue
				phone = ""
			end

			begin #8
				website = noko.css('#bizUrl a')[0]['href']
				website = admin_strip_text(website)
			rescue
				website = ""
			end

			begin #9
				parking = noko.css('.attr-BusinessParking')[1].text
				parking = admin_strip_text(parking)
			rescue
				parking = ""
			end

			begin #10
				attire = noko.css('.attr-RestaurantsAttire')[1].text
				attire = admin_strip_text(attire)
			rescue
				attire = ""
			end

			begin #11
				good_for_meal = noko.css('.attr-GoodForMeal')[1].text
				good_for_meal = admin_strip_text(good_for_meal)
			rescue
				good_for_meal = ""
			end

			begin #12
				hours = []
				noko.css('.attr-BusinessHours p').each do |hour|
					hours.push hour.text
				end
				hours = hours.join(',')
				hours = admin_strip_text(hours)
			rescue
				hours = ""
			end

			merchant.update_attributes(:name=>name,:address=>address,:city=>city,
				:state=>state,:zip=>zip,:category=>categories,
				:phone=>phone,:website=>website,:parking=>parking,
				:attire=>attire,:good_for_meal=>good_for_meal,:hours=>hours)

			begin #13
				music = noko.css('.attr-BestNights')[1].text
				music = admin_strip_text(music)
			rescue
				music = ""
			end

			begin #14
				best_nights = noko.css('.attr-Music')[1].text
				best_nights = admin_strip_text(best_nights)
			rescue
				best_nights = ""
			end

			begin #15
				noise_level = noko.css('.attr-NoiseLevel')[1].text
				noise_level = admin_strip_text(noise_level)
			rescue
				noise_level = ""
			end

			begin #16
				price_range = noko.css('#price_tip')[0].text.size.to_f
			rescue
				price_range = 0.0
			end

			begin #17
				rating = noko.css('#bizRating .rating i')[0]['title'].to_f
			rescue
				rating = 0.0
			end

			begin #18
				health_score = noko.css('.attr-InspectionScore')[1].text.to_i
			rescue
				health_score = 0
			end

			begin #19
				wifi = noko.css('.attr-WiFi')[1].text
				wifi = admin_strip_text(wifi)
			rescue
				wifi = ""
			end

			begin #20
				catering = noko.css('.attr-Caters')[1].text
				catering = admin_strip_text(catering)
			rescue
				catering = ""
			end

			begin #21
				dog_allowed = noko.css('.attr-DogsAllowed')[1].text
				dog_allowed = admin_strip_text(dog_allowed)
			rescue
				dog_allowed = ""
			end

			begin #22
				has_tv = noko.css('.attr-HasTV')[1].text
				has_tv = admin_strip_text(has_tv)
			rescue
				has_tv = ""
			end

			begin #23
				good_for_dancing = noko.css('.attr-GoodForDancing')[1].text
				good_for_dancing = admin_strip_text(good_for_dancing)
			rescue
				good_for_dancing = ""
			end

			begin #24
				alcohol = noko.css('.attr-Alcohol')[1].text
				alcohol = admin_strip_text(alcohol)
			rescue
				alcohol = ""
			end

			begin #25
				good_for_group = noko.css('.attr-RestaurantsGoodForGroups')[1].text
				good_for_group = admin_strip_text(good_for_group)
			rescue
				good_for_group = ""
			end

			begin #26
				good_for_kids = noko.css('.attr-GoodForKids')[1].text
				good_for_kids = admin_strip_text(good_for_kids)
			rescue
				good_for_kids = ""
			end

			begin #27
				accept_credit_card = noko.css('.attr-BusinessAcceptsCreditCards')[1].text
				accept_credit_card = admin_strip_text(accept_credit_card)
			rescue
				accept_credit_card = ""
			end

			begin #28
				good_for_reservation = noko.css('.attr-RestaurantsReservations')[1].text
				good_for_reservation = admin_strip_text(good_for_reservation)
			rescue
				good_for_reservation = ""
			end

			begin #29
				delivery = noko.css('.attr-RestaurantsDelivery')[1].text
				delivery = admin_strip_text(delivery)
			rescue
				delivery = ""
			end

			begin #30
				takeout = noko.css('.attr-RestaurantsTakeOut')[1].text
				takeout = admin_strip_text(takeout)
			rescue
				takeout = ""
			end

			begin #31
				wheelchair_accessible = noko.css('.attr-WheelchairAccessible')[1].text
				wheelchair_accessible = admin_strip_text(wheelchair_accessible)
			rescue
				wheelchair_accessible = ""
			end

			begin #32
				waiter_service = noko.css('.attr-RestaurantsTableService')[1].text
				waiter_service = admin_strip_text(waiter_service)
			rescue
				waiter_service = ""
			end

			begin #33
				happy_hours = noko.css('.attr-HappyHour')[1].text
				happy_hours = admin_strip_text(happy_hours)
			rescue
				happy_hours = ""
			end

			begin #34
				smoking_allowed = noko.css('.attr-Smoking')[1].text
				smoking_allowed = admin_strip_text(smoking_allowed)
			rescue
				smoking_allowed = ""
			end

			begin #35
				coat_check = noko.css('.attr-CoatCheck')[1].text
				coat_check = admin_strip_text(coat_check)
			rescue
				coat_check = ""
			end

			begin #36
				outdoor_seating = noko.css('.attr-OutdoorSeating')[1].text
				outdoor_seating = admin_strip_text(outdoor_seating)
			rescue
				outdoor_seating = ""
			end

			begin #37
				ambience = noko.css('.attr-Ambience')[1].text
				ambience = admin_strip_text(ambience)
			rescue
				ambience = ""
			end

			reviews = ""

			begin
				merchant.update_attributes(:name=>name,:address=>address,:city=>city,
										:state=>state,:zip=>zip,:category=>categories,
										:phone=>phone,:website=>website,:parking=>parking,
										:attire=>attire,:good_for_meal=>good_for_meal,:hours=>hours,
										:music=>music,:best_nights=>best_nights,:noise_level=>noise_level,
										:price_range=>price_range,:rating=>rating,:health_score=>health_score,
										:wifi=>wifi,:catering=>catering,:allow_dog=>dog_allowed,
										:has_tv=>has_tv,:good_for_dancing=>good_for_dancing,:alcohol=>alcohol,
										:good_for_group=>good_for_group,:good_for_kids=>good_for_kids,:accept_credit_card=>accept_credit_card,
										:delivery=>delivery,:takeout=>takeout,:wheelchair_accessible=>wheelchair_accessible,
										:waiter_service=>waiter_service,:happy_hours=>happy_hours,:smoking=>smoking_allowed,
										:coat_check=>coat_check,:outdoor_seating=>outdoor_seating,:ambience=>ambience,
										:reviews=>reviews,:failed=>false,:completed=>true)
			rescue => e
				merchant.update_attributes(:failed=>true)
			end
		end
	end

	def admin_strip_text(str)
		str.gsub(/\t|\n/,'')
		str.strip
	end

	def admin_get_html_from_link(type)
		while true
			arr = []
			links = Link.where(crawled: false, failed: false, domain: type).limit(100000)
			links.select do |link|
				href = link[:href]
				if href.match /\/biz\//
					arr.push(link)
				end
			end
			link = {}
			begin
				proxy_arr = [
					'64.78.77.126:80',
					'74.208.12.26:3128',
					'174.137.152.60:8080',
					'173.208.137.44:3128',
					'147.31.182.137:80',
					'107.23.180.148:8080',
					'107.21.102.102:80',
					'63.141.249.37:7808',
					'50.57.179.82:80',
					'199.30.136.117:7808',
					'208.110.83.202:3128',
					'108.61.89.152:8089',
					'173.213.96.229:7808',
					'23.22.4.54:80',
					'198.154.114.100:3128',
					'74.221.211.12:7808',
					'192.30.34.190:3128',
					'65.126.16.155:7808',
					'208.110.94.187:7808',
					'23.20.66.136:8080',
					'204.12.223.170:3128',
					'85.92.159.84:8080',
					'199.15.248.179:3128'
				]

				referer_arr = [
					"http://www.amazon.com",
					'http://www.priceline.com',
					'http://www.starbucks.com',
					'http://www.mcdownald.com',
					'http://www.burgerking.com',
					'http://www.yelp.com',
					'http://www.google.com',
					'http://www.mapquest.com',
					'http://maps.google.com'
				]
				
				user_agent_arr = [
					"Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_2; de-at) AppleWebKit/531.21.8 (KHTML, like Gecko) Version/4.0.4 Safari/531.21.10",
					"Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US) AppleWebKit/533.18.1 (KHTML, like Gecko) Version/4.0.5 Safari/531.22.7",
					"Mozilla/5.0 (Windows; U; Windows NT 5.2; en-US) AppleWebKit/533.17.8 (KHTML, like Gecko) Version/5.0.1 Safari/533.17.8",
					"Mozilla/5.0 (Windows; U; Windows NT 6.0; tr-TR) AppleWebKit/533.18.1 (KHTML, like Gecko) Version/5.0.2 Safari/533.18.5",
					"Mozilla/5.0 (Windows; U; Windows NT 6.1; sv-SE) AppleWebKit/533.19.4 (KHTML, like Gecko) Version/5.0.3 Safari/533.19.4",
					"Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_6; fr-fr) AppleWebKit/533.20.25 (KHTML, like Gecko) Version/5.0.4 Safari/533.20.27",
					"Ruby/1.8.7",
					"Mozilla/6.0 (Macintosh; Intel Mac OS X 10_6_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.110 Safari/537.36",
					"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_3)"
				]

				arr.each do |obj|
					link = obj
					
					href = link[:href]
		

					referer_index = rand(referer_arr.size)
					referer = referer_arr[referer_index]

					user_agent_index = rand(user_agent_arr.size)
					uagent = user_agent_arr[user_agent_index]

					proxy = '206.64.92.16:8000'
					proxy = false #"http://#{proxy}"

					Rails.logger.info link[:href]
					sleep rand(4) + 5
					Rails.logger.info 'sleep resume[---]'
					
					proxy = false
					html = open(href,:proxy => proxy, "User-Agent" => uagent,"Referer" => referer ).read

					unless html.blank?
						html = admin_strip_text(html)
						merchant = Merchant.new(html: html)
						merchant.save
						link.update_attributes(crawled: true, merchant_id: merchant[:id])
						Rails.logger.info '*****************  saved  ******************'
					else
						Rails.logger.info '*****************  blank html  ******************'
						link.update_attributes(failed: true)
					end
				end
			rescue => e
				Rails.logger.info '[eee] Error [eee]'
				Rails.logger.info e

				e = e.to_s
			
				if e.match(/redirection/)
					Rails.logger.info 'redirection detected [!!!] --- wait and reconnect'
					link.update_attribute(:failed,true)
				elsif e.match(/404/)
					Rails.logger.info '404 Not Found [!!!] Bad link, remove it --- wait and reconnect'
					link.destroy
				elsif e.match(/400/)
					Rails.logger.info '400 Not Found [!!!] Bad request, remove it --- wait and reconnect'
					link.destroy
				elsif e.match(/bad uri/i)
					Rails.logger.info 'Bad URI --- wait and reconnect'
					link.update_attribute(:failed,true)
				elsif e.match(/302|end of file reached|Connection refused|Connection reset/i) # refuse
					Rails.logger.info 'sleep --- wait then reconnect'
					sleep rand(3)
				elsif e.match(/nodename nor servname provided/)
					Rails.logger.info 'Bad Proxy [!!!] --- wait and reconnect'
					sleep rand(3)
					link.update_attribute(:failed,true)
				elsif e.match(/500/)
					Rails.logger.info '500 Exception --- wait and reconnect'
					sleep rand(3)
				elsif e.match(/502 Proxy Error/)
					Rails.logger.info '502 Exception'
				elsif e.match(/operation|timeout|time out|No route to host/i)
					Rails.logger.info 'timeout --- wait and reconnect'
					sleep rand(3)
				elsif e.match(/403/)
					Rails.logger.info '403 Exception'
				elsif e.match(/304/)
					Rails.logger.info '304 Exception --- wait and reconnect'
					link.update_attribute(:failed,true)
				elsif e.match(/503/)
					Rails.logger.info '503'
				else
					break
				end
			end
		end
	end




	def admin_visit_links_2(type)
		proxy_index = 0

		while true
			link = {}
			begin 
				linkArr = admin_get_num_unvisited_links_belong_to(type,200)
				linkArr.each do |obj|
					link = obj
					if link
						Rails.logger.info link['href']
						sleep rand(3) + 4
						Rails.logger.info 'sleep resume[---]'
						page = admin_get_page(link)
						hrefs = admin_collect_hrefs(type,page)
						link.update_attribute(:visited,true)
					end
				end
			rescue => e
				Rails.logger.info '[eee] Error [eee]'
				Rails.logger.info e

				e = e.to_s
			
				if e.match(/redirection/)
					Rails.logger.info 'redirection detected [!!!]'
					link.update_attribute(:failed,true)
				elsif e.match(/404/)
					Rails.logger.info '404 Not Found [!!!] Bad link, remove it'
					link.destroy
				elsif e.match(/400/)
					Rails.logger.info '400 Not Found [!!!] Bad request, remove it'
					link.destroy
				elsif e.match(/bad uri/i)
					Rails.logger.info 'Bad URI'
					link.update_attribute(:failed,true)
				elsif e.match(/302|end of file reached|Connection refused|Connection reset/i) # refuse
					Rails.logger.info 'sleep wait then reconnect'
					sleep 10 + rand(30)
				elsif e.match(/nodename nor servname provided/)
					Rails.logger.info 'Bad Proxy [!!!]'
					sleep 10 + rand(30)
					link.update_attribute(:failed,true)
				elsif e.match(/500/)
					Rails.logger.info '500 Exception'
					sleep 30 + rand(30)
				elsif e.match(/502 Proxy Error/)
					Rails.logger.info '502 Exception'
					break
				elsif e.match(/403/)
					Rails.logger.info '403 Exception'
					break
				else
					break
				end
			end
		end
	end

	def admin_get_a_unvisited_link_belongs_to(type)
		Link.where(domain: type, visited: false, failed: false).first
	end

	def admin_get_num_unvisited_links_belong_to(type,num)
		Link.where(domain: type, visited: false, failed: false).limit(num)
	end

	def admin_get_page(link)
		href = link[:href]
		proxy = #'192.227.139.106:7808'
		proxy = false #{}"http://#{proxy}"
		html = open(href,:proxy => proxy, "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.110 Safari/537.36","Referer" => "http://www.tripadvisor.com")
		page = Nokogiri::HTML(html)   
	end

	def admin_get_biz_links
		links = Link.all
		arr = []
		links.select do |link|
			if(link[:href].match(/\/biz\//))
				arr.push(link)
			end
		end

		return arr
	end

	def admin_collect_hrefs(type,page)
		links = page.css('a')
		links.each do |link|
			href = link['href']
			unless admin_is_unwanted_href?(href)
				href = admin_normalize_href(type,href)
				new_link = Link.new(href: href, visited: false, failed: false, crawled: false, domain: type).save
				if new_link
					Rails.logger.info '*****************  saved  ******************'
					Rails.logger.info href
				end
			end
		end 
	end

	def admin_normalize_href(type,href)
		if type == 'yelp'
			new_href = 'http://www.yelp.com'
		elsif type == 'trip_advisor'
			new_href = 'http://www.tripadvisor.com'
		end

		if href.match(/^\//)
			new_href += href
		elsif href.match(/^wwww\./)
			new_href = 'http://' + href
		end

		new_href = new_href.gsub(/#.*/,'')

		unless new_href.match(/\?userid/)
			new_href = new_href.gsub(/\?.*/,'')
		end
		return new_href
	end

	def admin_is_unwanted_href?(href)
		begin
			href.strip!
			if (href.match(/^#/) || # start with hash
				href.match(/https/) || # https
				href.match(/https?:\/\/\w{2}\.yelp/i) || # link to other countries like sv.yelp, nl.yelp, fr.yelp
				href.match(/https?:\/\/www\.yelp\.\w{2}$/) || # link to other countries like www.yelp.ca
				href.match(/https?:\/\/www\.yelp\.\w{2}\//) || # link to other countries like www.yelp.it/
				href.match(/https?:\/\/www\.yelp\.\w{2}\./) || # link to other countries like www.yelp.co.uk/
				href.match(/https?:\/\/www\.yelp\.com\.\w{2}$/) || # link to other countries like www.yelp.com.tr
				href.match(/https?:\/\/www\.yelp\.com\.\w{2}\/$/) || # link to other countries like www.yelp.com.tr
				href.match(/calendar_export/) ||
				href.match(/signup|login/i) || # signup or login page
				href.match(/^\/$/) || # home page
				href.match(/javascript/) || # javascript
				href.match(/write/) || # write a review
				href.match(/review/) || # review
				href.match(/talk/) ||
				href.match(/\/biz_photos\//) ||
				href.match(/upload/) ||
				href.match(/redirect/) ||
				href.match(/\/search/) ||
				href.match(/discuss/) ||
				href.match(/forum/) ||
				href.match(/topic/) ||
				href.match(/event/) ||
				href.match(/http:\/\/www\.yelp\.com$/) ||
				(href.match(/https?:\/\//) && !href.match(/yelp/))) # start with http but no yelp
				return true
			end
			return false
		rescue
			return true
		end
	end

	def scrap_trip_advisor

	end
end

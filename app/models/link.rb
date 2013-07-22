class Link < ActiveRecord::Base
	validates :href, presence: true, uniqueness: true

	# visited => if visited that link
	# crawled => if scraped data from that link
	# failed => if tried visit 3 times but failed
end

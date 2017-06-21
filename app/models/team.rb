class Team < ApplicationRecord
	has_many :teammembers
	belongs_to :member
	has_many :topics

	scope :active, -> () { where active: true }
end

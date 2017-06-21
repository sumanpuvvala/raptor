class Classification < ApplicationRecord
	has_many :topic

	scope :active, -> () { where active: true }
end

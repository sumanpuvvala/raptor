class Classification < ApplicationRecord
	has_many :topic, dependent: :restrict_with_exception

	scope :active, -> () { where active: true }
end

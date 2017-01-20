class Interest < ApplicationRecord
	belongs_to :topic
	belongs_to :member
end

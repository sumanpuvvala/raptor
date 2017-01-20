class NamedList < ApplicationRecord
	scope :list, -> (list_name) { where list_name: list_name }
end

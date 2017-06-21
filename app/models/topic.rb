class Topic < ApplicationRecord
	belongs_to :classification
	belongs_to :category
	belongs_to :team
	has_many :courses
	has_many :interests

	scope :name_includes, -> (topic_name) { where("name LIKE ?", "%#{topic_name}%") }
	scope :classification, -> (classification_id) { where classification_id: classification_id }
	scope :category, -> (category_id) { where category_id: category_id }
	scope :team, -> (team_id) { where team_id: team_id }
	scope :active, -> () { where active: true }
end

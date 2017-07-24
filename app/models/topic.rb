class Topic < ApplicationRecord
	belongs_to :classification
	belongs_to :category
	belongs_to :team
	has_many :courses, dependent: :restrict_with_exception
	has_many :interests

	scope :name_includes, -> (topic_name) { where("name LIKE ?", "%#{topic_name}%") }
	scope :classification, -> (classification_id) { where classification_id: classification_id }
	scope :category, -> (category_id) { where category_id: category_id }
	scope :team, -> (team_id) { where team_id: team_id }
	scope :active, -> () { where active: true }

#	before_destroy :check_for_courses
	before_destroy :remove_children 

	def total_courses 
		self.courses.active().count() 
	end

	private

#	def check_for_courses
#		if courses.count > 0
#		  errors.add(:base, "cannot delete topic while courses exist")
#		  return false
#		end
#	end

	def remove_children
		interests.destroy_all
	end

end

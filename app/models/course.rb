class Course < ApplicationRecord

	attr_accessor :rating

	belongs_to :member
	belongs_to :topic
	has_many :subscriptions

	has_many :course_links
	has_many :child_courses, :through => :course_links

	has_many :parent_course_links, :class_name => "CourseLink", :foreign_key => :child_course_id
	has_many :parent_courses, :through => :parent_course_links, :source => :course

	scope :name_includes, -> (course_name) { where("title LIKE ?", "%#{course_name}%") }
	scope :topic, -> (topic_id) { where topic_id: topic_id }
	scope :contributor, -> (member_id) { where member_id: member_id }
	scope :difficulty, -> (difficulty) { where difficulty: difficulty }
	scope :course_type, -> (course_type) { where course_type: course_type }
	scope :paid, -> () { where("cost_course not in (\"0\", \"-\", \"\")") }
	scope :active, -> () { where active: true }
end

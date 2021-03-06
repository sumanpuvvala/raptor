class Course < ApplicationRecord

	attr_accessor :rating

	belongs_to :member
	belongs_to :topic

	has_many :subscriptions
	has_many :urls, :class_name => "Urls", :foreign_key => :entity_id

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

  def average_rating
    self.subscriptions.average(:rating)
  end

before_destroy :clear_children

protected
  def clear_children
    subscriptions.destroy_all
    course_links.destroy_all
    parent_course_links.destroy_all

    @urls = Url.where(entity_id: self.id).where(entity: "course")
    @urls.destroy_all
  end

end

class CourseLink < ApplicationRecord
	belongs_to :course
	belongs_to :child_course, :class_name => 'Course'
end
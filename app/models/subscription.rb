class Subscription < ApplicationRecord
	belongs_to :course
	belongs_to :member

	attr_accessor :overdue

	scope :course, -> (course_id) { where course_id: course_id }
	scope :member, -> (member_id) { where member_id: member_id }
	scope :status, -> (status) { where status: status }
	scope :subscription, -> { where("status <> 'Recommended'") }
	scope :completion, -> { where("status in ('Completed', 'Certified')") }
	scope :inprogress, -> { where("status in ('In Progress')") }
end

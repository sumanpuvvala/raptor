class Member < ApplicationRecord

	attr_accessor :credits
	attr_accessor :credits_earned
	attr_accessor :credits_inprogress

	has_many :teams
	has_many :teammembers
	has_many :courses
	has_many :subscriptions
	has_many :interests

	scope :name_includes, -> (member_name) { where("name LIKE ?", "%#{member_name}%") }
	scope :stream, -> (stream) { where stream: stream }
	scope :manager, -> (manager) { where manager: manager }
	scope :title, -> (title) { where title: title }
	scope :active, -> () { where active: true }

before_destroy :clear_children

protected
  def clear_children
    teams.clear
    teammembers.destroy_all
    courses.clear
    subscriptions.destroy_all
    interests.destroy_all
  end

end

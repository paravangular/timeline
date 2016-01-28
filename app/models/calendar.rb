class Calendar < ActiveRecord::Base
	has_many :months
	has_many :eras
	has_many :lines

	belongs_to :user

	validates :name,
							presence: true

	accepts_nested_attributes_for :eras, :months, allow_destroy: true

	attr_accessor :days_in_month

end

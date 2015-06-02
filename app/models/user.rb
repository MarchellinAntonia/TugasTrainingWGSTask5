class User < ActiveRecord::Base
	validates :name, presence: true, length: {minimum: 3}
	validates :sex, presence: true, length: {minimum: 3}
	validates :dob, presence: true, length: {minimum: 3}
	validates_format_of :email, presence: true, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
	validates :phone, presence: true, length: {minimum: 6}, numericality: { only_integer: true }
	validates :address, presence: true, length: {minimum: 3}

has_many :comments
end

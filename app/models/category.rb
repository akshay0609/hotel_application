class Category < ActiveRecord::Base
  has_many :rooms
  validates :category_type, presence: true
  validates :facility, presence: true
  validates :price, presence: true, numericality: true
end
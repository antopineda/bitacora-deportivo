class Applause < ApplicationRecord
  has_one_attached :photo

  validates :name, presence: true
  validates :objective, presence: true
end

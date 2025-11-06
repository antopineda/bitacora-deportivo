class Game < ApplicationRecord
  has_one_attached :photo
  validates :name, :objective, presence: true
end

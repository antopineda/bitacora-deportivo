class Reflection < ApplicationRecord
  # Asociación con Active Storage para la foto de perfil
  has_one_attached :profile_photo

  # Validaciones
  validates :name, presence: true
  validates :reflection, presence: true
end

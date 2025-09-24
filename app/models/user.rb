class User < ApplicationRecord
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: { scope: :email, message: "Este correo ya esta en uso" }

  def full_name
    "#{first_name} #{last_name}"
  end
end

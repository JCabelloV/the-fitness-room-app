class Schedule < ApplicationRecord
  belongs_to :user
  belongs_to :trainer, class_name: "User"

  enum :status, {
    pending: 0,
    confirmed: 1,
    cancelled: 2,
    completed: 3
  }

  validates :starts_at, :ends_at, presence: true

  private

  def ends_after_starts
    return if starts_at.blank? || ends_at.blank?
    errors.add(:ends_at, "Debe ser mayor que la fecha de inicio") if ends_at <= starts_at
  end
end

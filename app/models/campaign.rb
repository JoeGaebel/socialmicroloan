class Campaign < ApplicationRecord
  MAX_LOAN_AMOUNT = 10000
  MINIMUM_DAYS_AHEAD = 3

  belongs_to :creator, class_name: 'User'

  validates :creator,     presence: true

  validates :title,       presence: true, length: { maximum: 100 }
  validates :subtitle,    presence: true, length: { maximum: 250 }
  validates :description, presence: true

  validates :goal_date,   presence: true
  validates :repayment_length, presence: true, inclusion: {
    in: [2, 3, 6, 12],
    message: "%{value} is not a valid repayment term"
  }
  validates :goal_amount, presence: true, numericality: { less_than_or_equal_to: MAX_LOAN_AMOUNT }
  validates :picture,     presence: true

  validate :goal_date_in_future, on: :create

  private

  def goal_date_in_future
    if goal_date < Date.today + 4.days
      errors.add(:goal_date, 'needs to be at least 3 days away')
    end
  end
end

class Campaign < ApplicationRecord
  MAX_LOAN_AMOUNT = 10000
  MINIMUM_DAYS_AHEAD = 3
  VALID_REPAYMENT_LENGTHS = [2, 3, 6, 12]
  VALID_INTEREST_RANGE = 0..30
  DATE_FORMAT = '%Y-%m-%d'
  default_scope -> { order(created_at: :desc) }

  mount_uploader :picture, PictureUploader

  belongs_to :creator, class_name: 'User'

  has_many :campaign_supports
  has_many :supporters,
    through: :campaign_supports,
    source: :user

  before_validation :maybe_convert_date

  validates :creator,     presence: true

  validates :title,       presence: true, length: { maximum: 100 }
  validates :subtitle,    presence: true, length: { maximum: 250 }
  validates :description, presence: true

  validates :goal_date,   presence: true
  validates :repayment_length, presence: true, inclusion: {
    in: VALID_REPAYMENT_LENGTHS,
    message: "%{value} is not a valid repayment term"
  }
  validates :interest_percent, presence: true, inclusion: {
    in: VALID_INTEREST_RANGE
  }

  validates :goal_amount, presence: true, numericality: { less_than_or_equal_to: MAX_LOAN_AMOUNT }
  validates :picture,     presence: true

  validate :goal_date_in_future, on: :create
  validate :picture_size

  def amount_left
    goal_amount - (pledged_amount)
  end

  def days_left
    (goal_date - Date.today).round
  end

  def pledged_amount
    supporters.sum(:support_amount)
  end

  def is_funded?
    goal_amount == pledged_amount
  end

  def percent_complete
    (pledged_amount.fdiv(goal_amount) * 100).round
  end

  private

  def goal_date_in_future
    return unless goal_date.present?
    if goal_date.mjd - Date.today.mjd < MINIMUM_DAYS_AHEAD
      errors.add(:goal_date, 'needs to be at least 3 days away')
    end
  end

  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, 'should be less than 5MB')
    end
  end

  def maybe_convert_date
    if goal_date.is_a?(String)
      begin
        parsed_date = Date.strptime(value, DATE_FORMAT)
        write_attribute(:goal_date, parsed_date)
      rescue ArgumentError
        write_attribute(:goal_date, nil)
      end
    end
  end
end

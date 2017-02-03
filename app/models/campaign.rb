class Campaign < ApplicationRecord
  MAX_LOAN_AMOUNT = 10000
  MINIMUM_DAYS_AHEAD = 3
  VALID_REPAYMENT_LENGTHS = [2, 3, 6, 12]
  VALID_INTEREST_RANGE = 0..50
  DATE_FORMAT = '%Y-%m-%d'

  mount_uploader :picture, PictureUploader

  belongs_to :creator, class_name: 'User'

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

  private

  def goal_date_in_future
    return unless goal_date.present?
    if goal_date < Date.today + (MINIMUM_DAYS_AHEAD + 1).days
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

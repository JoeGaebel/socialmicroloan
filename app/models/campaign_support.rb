class CampaignSupport < ApplicationRecord
  MINIMUM_SUPPORT_AMOUNT = 10
  belongs_to :campaign
  belongs_to :user

  validates :support_amount, numericality: { greater_than_or_equal_to: MINIMUM_SUPPORT_AMOUNT }
  validates :campaign_id, presence: true
  validates :user_id, presence: true
  validate :supporter_is_not_creator
  validate :amount_less_than_equal_to_amount_left
  validate :campaign_not_expired

  private

  def supporter_is_not_creator
    return unless user_id && campaign
    if campaign.creator_id == user_id
      errors.add(:user_id, 'cannot support their own campaign')
    end
  end

  def amount_less_than_equal_to_amount_left
    return unless support_amount && campaign
    if support_amount > campaign.amount_left
      errors.add(:support_amount, "can't be greater than goal amount")
    end
  end

  def campaign_not_expired
    return unless campaign
    errors.add(:campaign_id, "campaign is expired!") if campaign.expired?
  end
end

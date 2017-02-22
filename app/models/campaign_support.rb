class CampaignSupport < ApplicationRecord
  belongs_to :campaign
  belongs_to :user

  validates :campaign_id, presence: true
  validates :user_id, presence: true
  validate :supporter_is_not_creator

  private

  def supporter_is_not_creator
    if campaign.creator_id == user_id
      errors.add(:user_id, 'cannot support their own campaign')
    end
  end
end

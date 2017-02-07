class CampaignSupport < ApplicationRecord
  belongs_to :campaign
  belongs_to :user

  validates :campaign_id, presence: true
  validates :user_id, presence: true
end

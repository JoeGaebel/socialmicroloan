module CampaignsHelper
  def can_be_supported?(campaign)
    !campaign.is_funded? &&
    !current_user?(campaign.creator) &&
    !current_user.supported_campaigns.include?(campaign) &&
    !campaign.expired?
  end
end

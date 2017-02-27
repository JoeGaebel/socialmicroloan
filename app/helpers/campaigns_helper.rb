module CampaignsHelper
  def can_be_supported?(campaign)
    if current_user
      !current_user?(campaign.creator) &&
      !current_user.supported_campaigns.include?(campaign) &&
      !campaign.is_funded? &&
      !campaign.expired?
    else
      !campaign.is_funded? &&
      !campaign.expired?
    end
  end
end

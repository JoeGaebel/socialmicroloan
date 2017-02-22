class CampaignSupportsController < ApplicationController
  before_action :set_campaign
  before_action :ensure_user_logged_in
  before_action :ensure_not_already_supported
  before_action :ensure_user_is_connected

  def new
  end

  def create
    current_user.support(@campaign)
    respond_to do |format|
      format.html { redirect_to @campaign }
      format.js
    end
  end

  def set_campaign
    @campaign = Campaign.find(params[:campaign_id])
  end

  private

  def ensure_not_already_supported
    if current_user.supported_campaigns.include?(@campaign)
      flash[:danger] = "You've already supported this campaign!"
      redirect_to @campaign
    end
  end
end

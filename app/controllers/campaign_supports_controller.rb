class CampaignSupportsController < ApplicationController
  before_action :set_campaign
  before_action :ensure_user_logged_in
  before_action :ensure_not_already_supported
  before_action :ensure_user_is_connected
  before_action :ensure_user_not_creator

  def new
    @page_title = 'Support'
    @support = CampaignSupport.new
  end

  def create
    @support = CampaignSupport.new(support_params.merge({
      user_id: current_user.id,
      campaign_id: @campaign.id
    }))

    if @support.save
      flash[:success] = "Successfully supported the Campaign!"
      redirect_to @campaign
    else
      render :new
    end
  end

  private

  def set_campaign
    @campaign = Campaign.find(params[:campaign_id])
  end

  def support_params
    params.require(:campaign_support).permit(:support_amount, :require_interest)
  end

  def ensure_not_already_supported
    if current_user.supported_campaigns.include?(@campaign)
      flash[:danger] = "You've already supported this campaign!"
      redirect_to @campaign
    end
  end

  def ensure_user_not_creator
    redirect_to campaign_path(@campaign.id) if current_user?(@campaign.creator)
  end
end

class CampaignsController < ApplicationController
  before_action :ensure_user_logged_in, only: [:new, :create]
  before_action :correct_user,   only: :destroy
  before_action :ensure_user_is_connected, only: [:new, :create]

  include ApplicationHelper

  def create
    @campaign = current_user.campaigns.build(campaign_params)
    if @campaign.save
      flash[:success] = 'Campaign created!'
      redirect_to campaign_path(@campaign)
    else
      @page_title = 'New Campaign'
      render 'new'
    end
  end

  def new
    @campaign = current_user.campaigns.build
    @page_title = 'New Campaign'
  end

  def show
    @campaign = Campaign.find(params[:id])
    @page_title = remove_emoji(@campaign.title)
  end

  def destroy
    @campaign.destroy
    flash[:success] = 'Campaign deleted'
    redirect_to request.referrer || root_url
  end

  private

  def campaign_params
    params.require(:campaign).permit(
      :picture,
      :title,
      :subtitle,
      :description,
      :goal_date,
      :repayment_length,
      :interest_percent,
      :goal_amount
    )
  end

  def correct_user
    @campaign = current_user.campaigns.find_by(id: params[:id])
    redirect_to root_url if @campaign.nil?
  end
end

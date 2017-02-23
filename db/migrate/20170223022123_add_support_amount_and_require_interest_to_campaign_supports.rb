class AddSupportAmountAndRequireInterestToCampaignSupports < ActiveRecord::Migration[5.0]
  def change
    add_column :campaign_supports, :support_amount, :integer
    add_column :campaign_supports, :require_interest, :boolean
  end
end

class RemovePledgedAmountFromCampaigns < ActiveRecord::Migration[5.0]
  def change
    remove_column :campaigns, :pledged_amount
  end
end

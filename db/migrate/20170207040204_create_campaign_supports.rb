class CreateCampaignSupports < ActiveRecord::Migration[5.0]
  def change
    create_table :campaign_supports do |t|
      t.belongs_to :campaign
      t.belongs_to :user

      t.timestamps
    end

    add_index :campaign_supports, [:campaign_id, :user_id], unique: true
  end
end

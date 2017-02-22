require 'spec_helper'

describe CampaignSupport do
  before do
    @user = create(:user)
    @campaign = create(:campaign)

    @campaign_support = create(:campaign_support, {
      user_id: @user.id,
      campaign_id: @campaign.id
    })
  end

  it 'should be valid' do
    expect(@campaign_support).to be_valid
  end

  it { should validate_presence_of(:campaign_id) }
  it { should validate_presence_of(:user_id) }

  it 'should wire up the associations correctly' do
    expect(@user.supported_campaigns.length).to eq(1)
    expect(@user.supported_campaigns).to include(@campaign)

    expect(@campaign.supporters.length).to eq(1)
    expect(@campaign.supporters).to include(@user)
  end

  it 'should prevent creators from supporting their own campaigns' do
    my_campaign = create(:campaign, creator: @user)
    expect(@user.campaigns).to include(my_campaign)

    self_support = build(:campaign_support, {
      user_id: @user.id,
      campaign_id: my_campaign.id
    })

    expect(self_support).not_to be_valid
  end
end

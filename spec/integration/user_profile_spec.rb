describe 'User Profile' do
  before do
    Campaign.per_page = 1
    @user = create(:user)

    4.times do
      @user.campaigns << create(:campaign)
    end
  end

  describe 'displaying a profile' do
    it 'displays correctly' do
      get user_path(@user)
      assert_template 'users/show'
      assert_select 'title', @user.name + ' | Social Microloan'
      assert_select 'h1', text: @user.name
      assert_select 'h1>img.gravatar'
      assert_match @user.campaigns.count.to_s, response.body
      assert_select 'div.pagination', 1
      @user.campaigns.paginate(page: 1).each do |campaign|
        assert_select "div#campaign-#{campaign.id}"
      end
    end
  end
end

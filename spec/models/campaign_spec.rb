require 'spec_helper'

describe Campaign do
  before do
    @user = create(:user)
    @campaign = create(:campaign)

    expect(@campaign).to be_valid
  end

  describe 'validations' do
    subject { @campaign }

    it { should belong_to(:creator).class_name('User') }
    it { should validate_presence_of(:creator) }
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:subtitle) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:goal_date) }
    it { should validate_presence_of(:repayment_length) }
    it { should validate_presence_of(:goal_amount) }
    it { should validate_presence_of(:interest_percent) }
    it { should validate_length_of(:title).is_at_most(100) }
    it { should validate_length_of(:subtitle).is_at_most(250) }
    it { should validate_inclusion_of(:repayment_length).in_array([2, 3, 6, 12]) }
    it { should validate_inclusion_of(:interest_percent).in_range(Campaign::VALID_INTEREST_RANGE) }
    it { should validate_numericality_of(:goal_amount).is_less_than_or_equal_to(Campaign::MAX_LOAN_AMOUNT) }
    
    describe '#goal_date_in_future' do
      let(:min_days) { Campaign::MINIMUM_DAYS_AHEAD }

      context 'when the goal date is not in the future' do
        before do
          @campaign = build(:campaign, goal_date: 2.days.ago)
        end

        it 'is not valid' do
          @campaign.save
          expect(@campaign).not_to be_valid
        end
      end

      context 'when the goal date is 1 day below the limit' do
        before do
          @campaign = build(:campaign, goal_date: (min_days - 1).days.from_now)
        end

        it 'is not valid' do
          @campaign.save
          expect(@campaign).not_to be_valid
        end
      end

      context 'when the goal date is at the limit' do
        before do
          @campaign = build(:campaign, goal_date: min_days.days.from_now)
        end

        it 'is valid' do
          @campaign.save
          expect(@campaign).to be_valid
        end
      end

      context 'when the goal date is greater than the limit' do
        before do
          @campaign = build(:campaign, goal_date: (min_days + 1).days.from_now)
        end

        it 'is valid' do
          @campaign.save
          expect(@campaign).to be_valid
        end
      end
    end
  end
end

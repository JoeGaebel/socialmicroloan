require 'spec_helper'

describe Campaign do
  before do
    @user = create(:user)
    @campaign = create(:campaign)

    expect(@campaign).to be_valid
  end

  describe 'associations' do
    it { should belong_to(:creator).class_name('User') }

    it { should have_many(:campaign_supports) }
    it { should have_many(:supporters).through(:campaign_supports).source(:user) }

    context 'with supported campaigns' do
      before do
        @campaign = create(:campaign)
        create(:campaign_support, { campaign_id: @campaign.id })
      end

      it 'has supporters' do
        expect(@campaign.supporters).to be_present
      end
    end
  end

  describe 'validations' do
    subject { @campaign }
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
          @campaign = build(:campaign, goal_date: (min_days - 2).days.from_now)
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

  describe '#maybe_convert_date' do
    context 'when goal_date is a Date' do
      it 'keeps the date as is' do
        expect{ @campaign.save }.not_to change { @campaign.goal_date }
      end
    end

    context 'when goal_date is a String' do
      context 'in the correct form' do
        let(:goal_date) { '2017-12-03' }

        it 'parses and sets the value' do
          @campaign.goal_date = goal_date
          @campaign.save

          converted_date = Date.strptime(goal_date, described_class::DATE_FORMAT)
          expect(@campaign.goal_date).to eq(converted_date)
        end
      end

      context 'in the wrong form' do
        let(:goal_date) { '2017-12-03' }

        it 'sets the value as nil' do
          @campaign.goal_date = 'goal_date'
          @campaign.save
          expect(@campaign.goal_date).to be_nil
        end
      end
    end
  end

  describe '#days_left' do
    let(:number_of_days) { 4 }

    before do
      @time = Date.parse('12/03/2016')
      allow(Date).to receive(:today).and_return(@time)
      @campaign.update_attribute(:goal_date, @time + number_of_days.days)
    end

    it 'returns a rounded number of days' do
      expect(@campaign.days_left).to eq(number_of_days)
    end
  end

  describe '#is_funded?' do
    subject { @campaign.is_funded? }

    context 'when the goal amount is equal to the pledged amount' do
      before do
        create(:campaign_support, campaign: @campaign, support_amount: @campaign.goal_amount)
      end

      it { should be_truthy }
    end

    context 'when the goal amount is less than the pledged amount' do
      before do
        expect(@campaign.pledged_amount).to be < @campaign.goal_amount
      end

      it { should be_falsey }
    end
  end

  describe '#pledged_amount' do
    let(:support_amount1) { 100 }
    let(:support_amount2) { 200 }

    it 'sums the amount of supporter amounts' do
      expect(@campaign.pledged_amount).to eq(0)

      create(:campaign_support, { campaign: @campaign, support_amount: support_amount1 })
      create(:campaign_support, { campaign: @campaign, support_amount: support_amount2 })

      expect(@campaign.pledged_amount).to eq(support_amount1 + support_amount2)
    end
  end

  describe '#percent_complete' do
    it 'returns the correct percent' do
      expect(@campaign.percent_complete).to eq(0)
      create(:campaign_support, { campaign: @campaign, support_amount: (@campaign.goal_amount / 2) })
      expect(@campaign.percent_complete).to eq(50)
      create(:campaign_support, { campaign: @campaign, support_amount: (@campaign.goal_amount / 3) })
      expect(@campaign.percent_complete).to eq(83)
    end
  end

  describe '#expired?' do
    context 'when the campaign is funded' do
      before do
        allow(@campaign).to receive(:is_funded?).and_return(true)
      end

      context 'when the day has passed' do
        before do
          @campaign.update_attribute(:goal_date, 1.day.ago)
        end

        it 'returns true' do
          expect(@campaign.expired?).to be_falsey
        end
      end

      context 'when the day is today' do
        before do
          @campaign.update_attribute(:goal_date, Date.today)
        end

        it 'returns false' do
          expect(@campaign.expired?).to be_falsey
        end
      end

      context 'when the day is in the future' do
        before do
          @campaign.update_attribute(:goal_date, 2.days.from_now)
        end

        it 'returns false' do
          expect(@campaign.expired?).to be_falsey
        end
      end
    end

    context 'when the campaign is not funded' do
      before do
        allow(@campaign).to receive(:is_funded?).and_return(false)
      end

      context 'when the day has passed' do
        before do
          @campaign.update_attribute(:goal_date, 1.day.ago)
        end

        it 'returns true' do
          expect(@campaign.expired?).to be_truthy
        end
      end

      context 'when the day is today' do
        before do
          @campaign.update_attribute(:goal_date, Date.today)
        end

        it 'returns false' do
          expect(@campaign.expired?).to be_falsey
        end
      end

      context 'when the day is in the future' do
        before do
          @campaign.update_attribute(:goal_date, 2.days.from_now)
        end

        it 'returns false' do
          expect(@campaign.expired?).to be_falsey
        end
      end
    end
  end
end

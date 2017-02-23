require 'spec_helper'

describe CampaignsController do
  render_views

  before do
    @user = create(:user)
    allow_any_instance_of(User).to receive(:connected?) { true }
  end

  describe '#new' do
    context 'when logged in' do
      before do
        log_in(@user)
      end

      it 'renders the new page' do
        get :new
        assert_template 'campaigns/new'
      end
    end

    context 'when not logged in' do
      before do
        expect(is_logged_in?).to eq(false)
      end

      it 'redirects to login' do
        get :new
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe '#create' do
    let(:picture_mock) { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/boat.jpg')) }
    let(:valid_params) {{
      picture: picture_mock,
      title: 'The most successful campaign EVER',
      subtitle: 'Okay but seriously I definitely need this money',
      description: 'So I am going on the keto diet, and I need a bunch of money for bacon.',
      goal_date: 2.weeks.from_now.strftime(Campaign::DATE_FORMAT),
      repayment_length: '3',
      interest_percent: '20',
      goal_amount: '3000',
    }}

    let(:invalid_params) {{
      picture: nil,
      title: nil,
      subtitle: nil,
      description: nil,
      goal_date: nil,
      repayment_length: nil,
      interest_percent: nil,
      goal_amount: nil
    }}

    let(:sneaky_params) { valid_params.merge({
      pledged_amount: 3000,
      creator_id: @user.id + 1
    })}

    def do_request(options = {})
      post :create, params: { campaign: options }
    end

    context 'when logged in' do
      before do
        log_in(@user)
      end

      context 'with valid params' do
        it 'creates a campaign' do
          expect { do_request(valid_params) }.to change {
            Campaign.count
          }.by(1)

          expect(response).to redirect_to(Campaign.last)
        end
      end

      context 'with disallowed params' do
        it 'disallows setting' do
          expect { do_request(sneaky_params) }.to change {
            Campaign.count
          }.by(1)

          expect(assigns[:campaign].pledged_amount).to be_nil
          expect(assigns[:campaign].creator_id).to eq(@user.id)
        end
      end

      context 'with invalid params' do
        it 'redirects and shows errors' do
          expect { do_request(invalid_params) }.
            not_to change { Campaign.count }

          assert_template 'campaigns/new'
          assert_select 'div#error_explanation'
          assert_select 'div.field_with_errors'
        end
      end
    end

    context 'when not logged in' do
      before do
        expect(is_logged_in?).to eq(false)
      end

      it 'redirects to login' do
        do_request
        expect(response).to redirect_to(login_path)
      end
    end
  end
end

require 'spec_helper'

describe CampaignsController do
  describe '#new' do
    it 'renders the new page' do
      get :new
      assert_template 'campaigns/new'
    end
  end
end

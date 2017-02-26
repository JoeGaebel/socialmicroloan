class StaticPagesController < ApplicationController
  def home
    @display_campaign = Campaign.find(0)
    @popular_campaigns = Campaign.where("id != ?", 0).limit(3)
  end

  def help
    @page_title = 'Help'
  end

  def about
    @page_title = 'About'
  end

  def contact
    @page_title = 'Contact'
  end

  def signup
    @page_title = 'Sign up'
  end
end

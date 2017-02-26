class StaticPagesController < ApplicationController
  def home
    @display_campaign = display_campaign
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

  private

  def display_campaign
    you = User.find_by(id: 0)
    unless you.present?
      you = User.create({
        id: 0,
        name: 'You',
        email: 'you@socialmicro.loan',
        password: 'password',
        activated: true,
        activated_at: Time.zone.now
      })
    end

    campaign = Campaign.find_by(id: 0)
    unless campaign.present?
      campaign = Campaign.create!({
        id: 0,
        creator: you,
        title: "That thing you've always dreamed of",
        subtitle: "but didn't have the support you needed",
        description: "this is an example",
        goal_date: 1.year.from_now,
        repayment_length: 3,
        interest_percent: 5,
        goal_amount: 5000,
        picture:  File.open("#{Rails.root}/spec/fixtures/skydive1.gif")
      })
    end

    campaign
  end
end

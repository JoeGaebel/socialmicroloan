class CreateCampaigns < ActiveRecord::Migration[5.0]
  def change
    create_table :campaigns do |t|
      t.string :title
      t.string :subtitle
      t.text :description

      t.date :goal_date
      t.integer :repayment_length
      t.integer :interest_percent

      t.integer :goal_amount
      t.integer :pledged_amount

      t.string :picture

      t.belongs_to :creator, class_name: 'User'
      t.timestamps
    end
  end
end

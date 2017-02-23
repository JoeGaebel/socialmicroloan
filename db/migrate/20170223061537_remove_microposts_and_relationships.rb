class RemoveMicropostsAndRelationships < ActiveRecord::Migration[5.0]
  def change
    drop_table :relationships
    drop_table :microposts
  end
end

class AddLinkIdToVisits < ActiveRecord::Migration
  def change
    add_column :visits, :link_id, :integer
  end
end

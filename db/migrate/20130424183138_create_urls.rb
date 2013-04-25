class CreateUrls < ActiveRecord::Migration
  def change
    create_table :urls do |t|
      t.string :original
      t.integer :link_id

      t.timestamps
    end
    
    add_index :urls, :original
  end
end

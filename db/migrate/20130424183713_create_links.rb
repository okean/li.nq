class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string :identifier

      t.timestamps
    end
    
    add_index :links, :identifier
  end
end

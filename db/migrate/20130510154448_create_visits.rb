class CreateVisits < ActiveRecord::Migration
  def change
    create_table :visits do |t|
      t.string :ip
      t.string :country

      t.timestamps
    end
    
    add_index :visits, :created_at
    add_index :visits, :country
  end
end

class CreateMatchings < ActiveRecord::Migration
  def self.up
    create_table :matchings do |t|
      t.integer :helper_id
      t.integer :helped_id
      t.string :type

      t.timestamps
    end
  end

  def self.down
    drop_table :matchings
  end
end

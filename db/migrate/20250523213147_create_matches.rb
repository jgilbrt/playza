class CreateMatches < ActiveRecord::Migration[7.1]
  def change
    create_table :matches do |t|
      t.references :team, null: false, foreign_key: true
      t.string :opponent_name
      t.datetime :date
      t.string :location
      t.integer :score_own
      t.integer :score_opponent

      t.timestamps
    end
  end
end

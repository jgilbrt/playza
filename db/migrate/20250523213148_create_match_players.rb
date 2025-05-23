class CreateMatchPlayers < ActiveRecord::Migration[7.1]
  def change
    create_table :match_players do |t|
      t.references :match, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :status
      t.string :role
      t.integer :goals_scored
      t.integer :assists

      t.timestamps
    end
  end
end

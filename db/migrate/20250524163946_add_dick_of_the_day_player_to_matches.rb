class AddDickOfTheDayPlayerToMatches < ActiveRecord::Migration[7.1]
  def change
    add_column :matches, :dick_of_the_day_player_id, :bigint
  end
end

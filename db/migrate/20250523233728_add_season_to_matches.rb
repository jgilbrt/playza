class AddSeasonToMatches < ActiveRecord::Migration[7.1]
  def change
    add_column :matches, :season, :string
  end
end

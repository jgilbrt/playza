class AddLineupToMatches < ActiveRecord::Migration[7.0]
  def change
    add_column :matches, :lineup_starters, :integer, array: true, default: []
    add_column :matches, :lineup_substitutes, :integer, array: true, default: []
  end
end

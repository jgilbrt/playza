class AddHasHappenedToMatches < ActiveRecord::Migration[7.1]
  def change
    add_column :matches, :has_happened, :boolean
  end
end

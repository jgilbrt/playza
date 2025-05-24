class AddDotdDetailsToMatches < ActiveRecord::Migration[7.1]
  def change
    add_column :matches, :dotd_punishment, :string
  end
end

class AddRoleAndTeamToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :role, :string
    add_reference :users, :team, null: false, foreign_key: true
  end
end

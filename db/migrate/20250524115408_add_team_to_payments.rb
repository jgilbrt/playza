class AddTeamToPayments < ActiveRecord::Migration[7.1]
  def change
    add_reference :payments, :team, null: false, foreign_key: true
  end
end

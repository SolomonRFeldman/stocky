class AddBalanceToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :balance, :numeric, :default => 5000
  end
end

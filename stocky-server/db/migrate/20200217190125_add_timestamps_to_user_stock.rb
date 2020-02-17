class AddTimestampsToUserStock < ActiveRecord::Migration[6.0]
  def change
    add_timestamps :user_stocks, null: true 
    now = DateTime.now
    UserStock.update_all(created_at: now, updated_at: now)
    change_column_null :user_stocks, :created_at, null: false
    change_column_null :user_stocks, :updated_at, null: false
  end
end

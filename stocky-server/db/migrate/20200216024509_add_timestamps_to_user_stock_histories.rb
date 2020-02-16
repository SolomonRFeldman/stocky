class AddTimestampsToUserStockHistories < ActiveRecord::Migration[6.0]
  def change
    add_column :user_stock_histories, :created_at, :datetime, null: false
    add_column :user_stock_histories, :updated_at, :datetime, null: false
  end
end

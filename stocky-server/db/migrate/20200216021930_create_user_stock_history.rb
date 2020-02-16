class CreateUserStockHistory < ActiveRecord::Migration[6.0]
  def change
    create_table :user_stock_histories do |t|
      t.integer :user_id
      t.integer :stock_id
      t.integer :shares
      t.numeric :price
    end
  end
end

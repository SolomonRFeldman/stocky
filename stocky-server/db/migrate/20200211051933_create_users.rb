class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    enable_extension :citext

    create_table :users do |t|
      t.citext :name, null: false
      t.citext :email, null: false, unique: true
      t.string :password_digest, null: false
      t.timestamps
    end
  end
end

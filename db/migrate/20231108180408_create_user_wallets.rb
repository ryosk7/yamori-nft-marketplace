class CreateUserWallets < ActiveRecord::Migration[7.1]
  def change
    create_table :user_wallets do |t|
      t.string :address

      t.timestamps
    end
  end
end

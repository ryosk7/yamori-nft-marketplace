class CreateNftCollections < ActiveRecord::Migration[7.1]
  def change
    create_table :nft_collections do |t|
      t.string :name
      t.string :contract_address
      t.string :image
      t.string :creater_name
      t.string :creater_image
      t.string :chain

      t.timestamps
    end
  end
end

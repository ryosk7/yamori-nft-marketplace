class NftCollectionsController < ApplicationController
  before_action :set_nft_collection, only: [:show]

  def index
    @nft_collections = NftCollection.all
  end

  def show
    nft_row_datas = Web3Api::Moralis::Client.nfts_by_contract(
      chain: @nft_collection.chain,
      address: @nft_collection.contract_address,
      limit: 100)
    nft_token_datas = nft_row_datas["result"].map do |data|
      next if data.nil?
      next if data["token_address"].nil?
      next if data["metadata"].nil?
      next if data["minter_address"].nil?
      {
        token_address: data["token_address"],
        metadata: JSON.parse(data["metadata"]),
        minter_address: data["minter_address"],
      }
    end

    nft_token_datas.compact!
    @nfts = Kaminari.paginate_array(nft_token_datas)
                    .page(params[:page]).per(12)
  end

  private

  def set_nft_collection
    @nft_collection = NftCollection.find(params[:id])
  end
end

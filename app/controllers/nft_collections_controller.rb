class NftCollectionsController < ApplicationController
  def index
    @nft_collections = NftCollection.all
  end

  def show
  end
end

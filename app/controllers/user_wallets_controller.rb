class UserWalletsController < ApplicationController
  def create
    message = params["message"]
    address = params["address"]
    signature = params["signature"]


    if Eth::Signature.verify message, signature, address
      @user_wallet = UserWallet.find_by(address: address)
      if @user_wallet.present?
        session[:user_wallet_id] = @user_wallet.id
        render json: { logged_in: session[:user_wallet_id].present? }
        return
      end

      eth_address = Eth::Address.new address
      if eth_address.valid?
        @user_wallet = UserWallet.find_or_create_by(address: address)
        session[:user_wallet_id] = @user_wallet.id
        render json: { connected: session[:user_wallet_id].present? }
      end
    end
  end
end

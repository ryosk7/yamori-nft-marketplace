module UserWalletsHelper
  def current_user_wallet
    @current_user_wallet ||= UserWallet.find_by(id: session[:user_wallet_id])
  end
end

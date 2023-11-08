module Web3Api
  module Moralis
    class Client
      BASE_URI = "https://deep-index.moralis.io/api/v2.2/nft"
      def self.nfts_by_contract(chain:, address:, limit:)
        url = "#{BASE_URI}/#{address}"
        client = Faraday.new(url: url)
        params = {
          chain: chain,
          limit: limit
        }
        response = client.get do |req|
          req.headers = self.headers
          req.params = params
        end
        JSON.parse(response.body)
      end
      private
      def self.headers
        {
          "Content-Type": "application/json",
          "x-api-key": Rails.application.credentials.moralis[:api_key]
        }
      end
    end
  end
end
class NftCollection < ApplicationRecord
  def self.replaced_ipfs_image_url(ipfs_image_link)
    return ipfs_image_link if ipfs_image_link.exclude?('ipfs://')
    "http://ipfs.io/ipfs/#{ipfs_image_link.sub('ipfs://', '')}"
  end
end

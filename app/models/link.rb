class Link < ActiveRecord::Base
  attr_accessible :name, :url, :price, :address, :web, :phone, :product
end

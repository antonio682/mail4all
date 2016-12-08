class OutlookSerializer < ActiveModel::Serializer
  extend ActiveModel::Naming
 
 attributes :email_recieved, :recieved_list, :send_list, :spam_list  

  def initialize()
   
  end
 
  def to_model
    # You will get to_model error, if you don't have this dummy method
  end
  # You need this otherwise you get an error
  def persisted?
    false
  end
end
class RentalUnitSerializer < ActiveModel::Serializer
  attributes :id, :address, :rooms, :bathrooms, :price, :price_per_room
  belongs_to :user
end
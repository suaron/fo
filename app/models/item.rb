class Item < ActiveRecord::Base
  belongs_to :order

  validates_presence_of :title
end

class User < ActiveRecord::Base
  belongs_to :company

  validates_presence_of :email
end

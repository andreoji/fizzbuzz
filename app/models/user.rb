class User < ApplicationRecord
  validates_presence_of :username, :password
end

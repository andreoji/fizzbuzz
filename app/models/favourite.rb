class Favourite < ApplicationRecord
  validates_presence_of :number
  belongs_to :user
end

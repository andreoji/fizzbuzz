class Favourite < ApplicationRecord
  validates_presence_of :number, null: false
  belongs_to :user
end

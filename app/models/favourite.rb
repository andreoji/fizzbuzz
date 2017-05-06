class Favourite < ApplicationRecord
  validates_presence_of :number, uniqueness: true, null: false
  belongs_to :user
end

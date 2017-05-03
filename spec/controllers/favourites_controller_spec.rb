require 'rails_helper'

RSpec.describe FavouritesController, :type => :controller do
  it 'gets a users favourites' do
    user = create(:user, username: 'batman', password: 'secret')
    user_f = create(:user_with_favourites)
    puts "****** user: #{user.id} ******"#user.valid?
    puts "****** user_f: #{user_f.favourites.length} ******"#user.valid?
    puts "****** user_f: #{user_f.favourites.inspect} ******"#user.valid?
  end
end

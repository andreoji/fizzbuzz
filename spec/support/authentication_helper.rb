module AuthenticationHelper
  def sign_in_as_a_valid_program
    @user ||= create(:user, username: 'api_client', password: 'elixir')
    if user = User.valid_login?(@user.username, @user.password)
      user.allow_token_to_be_used_only_once
      user.token 
    end
  end
end

RSpec.configure do |config|
  config.include AuthenticationHelper, :type=>:request
end

class AuthenticateUser < ApplicationService
  def initialize(email, password)
    @email = email
    @password = password
  end

  private

  attr_accessor :email, :password

  def call
    if authenticate_user.present?
      { token: JsonWebToken.encode(user_id: authenticate_user.id, exp: 7.days.from_now, user_type: 'User') }
    end
  end

  def authenticate_user
    user = User.find_by(email: email)
    if user.present?
      if user&.authenticate(password)
        return user
      else
        errors.add :user_authentication, I18n.t('errors.invalid_credentials')
      end
    else
      errors.add :user_authentication, I18n.t('errors.account_not_found')
    end
  end
end

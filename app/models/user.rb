class User < ActiveRecord::Base
  has_many :players

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise  :database_authenticatable, :rememberable, :registerable, :recoverable,
          :trackable, :validatable, :omniauthable

  has_preferences do
    preference :show_email
    preference :show_gender
    preference :show_interests
  end

  def self.find_for_facebook_oauth(access_token, _)
    data = access_token.extra.raw_info
    user = User.find_by_email(data['email'])
    return user if user

    params = User.read_oauth_params(data)
    User.create!(params)
  end

  def self.read_oauth_params(data)
    {
      email: data['email'],
      password: Devise.friendly_token[0,20],
      gender: data['gender'].try(:first),
      first_name: data['first_name'],
      last_name: data['last_name'],
      birth_date: data['birthday'].try(:to_date),
      data_dump: data.inspect.to_s
    }
  end

  def is_admin?
    admin?
  end

  def deletable?
    !admin?
  end

  def greeting
    full_name || email
  end

  def full_name
    [first_name, last_name].compact.join(' ')
  end
end

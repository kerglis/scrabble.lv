class User < ActiveRecord::Base

  has_many :players

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :rememberable, :registerable, :recoverable, :trackable, :validatable, :omniauthable

  has_preferences do
    preference :show_email
    preference :show_gender
    preference :show_interests
  end

  def self.find_for_facebook_oauth(access_token, signed_in_resource = nil)
    data = access_token.extra.raw_info
    if user = User.find_by_email(data["email"])
      user
    else
      # Create a new user

      # data = {"name"=>"Kristaps Ērglis", "timezone"=>2, "gender"=>"male",
      # "inspirational_people"=>[{"name"=>"Mozart", "id"=>"106554719381817"}, {"name"=>"Carlos Castaneda", "id"=>"32205633205"}, {"name"=>"Osho", "id"=>"57072960268"}],
      # "id"=>"1514824144", "birthday"=>"09/04/1973", "last_name"=>"Ērglis", "updated_time"=>"2010-10-30T17:04:46+0000", "verified"=>true, "locale"=>"lv_LV",
      # "hometown"=>{"name"=>"Riga, Latvia", "id"=>"111536985531661"}, "link"=>"http://www.facebook.com/kristaps.erglis",
      # "sports"=>[{"name"=>"Speedminton", "id"=>"102180736490825"}, {"name"=>"Karting", "id"=>"182782171739071"}, {"name"=>"Squash", "id"=>"109469199070946"}],
      # "email"=>"kristaps.erglis@gmail.com", "first_name"=>"Kristaps"}

      params = User.read_oauth_params(data)
      User.create!(params)
    end
  end

  def self.read_oauth_params(data)
    params = {
      :email =>       data["email"],
      :password =>    Devise.friendly_token[0,20],
      :gender =>      data["gender"].try(:first),
      :first_name =>  data["first_name"],
      :last_name =>   data["last_name"],
      :birth_date =>  data["birthday"].try(:to_date),
      :data_dump =>   data.inspect.to_s
    }
  end

  def is_admin?
    admin?
  end

  def deletable?
    ! admin?
  end

  def greeting
    full_name || email
  end

  def full_name
    [first_name, last_name].compact.join(" ")
  end

  def age
    (! birth_date.blank?) ? (Time.now.to_date - birth_date.to_date).to_i/365 : 0
  end

end
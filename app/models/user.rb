class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me

  has_many :time_entries
  has_one :user_preference

  def role? check
    role == check.to_s
  end

  def name
  	email.split("@").first.gsub(".", " ").titleize
  end

  def user_preference
    super || UserPreference.create(user: self)
  end

end

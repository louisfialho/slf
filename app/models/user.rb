class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  has_many :shelves, dependent: :destroy
  validate :valid_phone_num, on: :create
  validates :username, format: { with: /\A[a-zA-Z0-9]+\Z/, message: ": please only use letters and numbers" }
  validates_uniqueness_of :username, message: ": this username is already taken"
  before_create :generate_extension_auth_token
  after_create :create_shelf_and_space_for_Telegram_items, :add_telegram_hash, :titleize_first_last_name, :set_username_on_shelf, :give_free_credits

  require "base64"

  def set_username_on_shelf # for url
    shelf = self.shelves.first
    shelf.username = self.username
    shelf.save
  end

  def give_free_credits
    self.tts_balance_in_min = 15
    self.save
  end

  def create_shelf_and_space_for_Telegram_items
      shelf = Shelf.new(user_id: self.id)
      shelf.save
      space = Space.new(name: "🤖 Added by Bot", position: 1)
      space.save
      shelf.spaces << space
  end

  def add_telegram_hash
    user_id = self.id.to_s
    telegram_hash = Base64.urlsafe_encode64(user_id, padding: false)
    if User.find_by(telegram_hash: telegram_hash).nil? == true  #check that telegram_hash has not already been attributed
      self.telegram_hash = telegram_hash
      self.save
    end
    #to go further: else, generate a random hash, check if it has not already been attributed. if it has repeat.
  end

  def generate_extension_auth_token
    self.chrome_auth_token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless User.exists?(chrome_auth_token: random_token)
    end
  end

  def titleize_first_last_name
    self.first_name = self.first_name.titleize
    self.last_name = self.last_name.titleize
    self.save
  end

  def valid_phone_num
    account_sid = ENV['TWILIO_ACCOUNT_SID']
    auth_token = ENV['TWILIO_AUTH_TOKEN']
    @client = Twilio::REST::Client.new(account_sid, auth_token)
    phone_number = @client.lookups.v1.phone_numbers(self.phone_number).fetch
    rescue
      errors.add(:phone_number, "is not a valid phone number")
  end

end

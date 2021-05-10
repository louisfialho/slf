class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  has_many :shelves, dependent: :destroy

  after_create :create_shelf_and_space_for_Telegram_items, :add_telegram_hash, :titleize_first_last_name

  require "base64"

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

  def titleize_first_last_name
    self.first_name = self.first_name.titleize
    self.last_name = self.first_name.titleize
    self.save
  end

end

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  attr_accessible :name
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :moods
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?
end

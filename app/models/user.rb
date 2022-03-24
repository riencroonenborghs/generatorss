class User < ApplicationRecord
  include Uuid

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :trackable, :rememberable, :validatable

  has_many :subscriptions, dependent: :destroy
  has_many :filters, dependent: :destroy
end

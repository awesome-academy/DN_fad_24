class User < ActiveRecord::Base
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  attr_accessor :activation_token
  before_save :downcase_email

  devise :database_authenticatable, :registerable, :confirmable,
    :recoverable, :rememberable, :validatable, :timeoutable, :lockable

  enum role: {guess: 0, admin: 1}

  mount_uploader :picture, PictureUploader

  has_many :orders
  has_many :contacts, dependent: :destroy
  has_many :reviews, dependent: :destroy

  scope :sort_users, ->{order(confirmed_at: :desc)}

  validates :name, presence: true,
            length: {maximum: Settings.users.name.maximum}
  validates :email, presence: true,
            length: {maximum: Settings.users.email.maximum},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}
  validates :phone, presence: true, numericality: true

  CSV_ATTRIBUTES = %w(name email phone).freeze

  def downcase_email
    email.downcase!
  end
end

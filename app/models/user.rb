class User < ActiveRecord::Base
  has_many :wikis

  before_save { self.role ||= :member }

  enum role: [:member, :premium, :admin]
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  def avatar_url(size)
  	gravatar_id = Digest::MD5::hexdigest(self.email).downcase
  	"http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}"
  end       
end

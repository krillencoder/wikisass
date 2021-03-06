class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :avatar, :avatar_cache
  # attr_accessible :title, :body
  has_many :wikis, dependent: :destroy
  has_one :subscription
  has_many :collaborations
  has_many :shared_wikis, through: :collaborations, source: :wiki

  
  before_create :set_member
  mount_uploader :avatar, AvatarUploader

  ROLES =%w[member premium]
  def role?(base_role)
  role.nil? ? false : ROLES.index(base_role.to_s) <= ROLES.index(role)
end

def self.all_but(user)
  where('id != ?', user.id)
end

def wikis_editable_by_user
  self.wikis + self.shared_wikis
end

private

  def set_member
  	self.role = 'member'
  end
end

require 'digest/sha1'

class User < ApplicationRecord
  
  belongs_to :person, optional: true

  validates_presence_of     :firstname, :lastname
  validates_uniqueness_of   :email
  validates_format_of       :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates_length_of       :password, minimum: 6,    if: :validate_password?
  validates_confirmation_of :password,                if: :validate_password?
  validates_presence_of     :password_confirmation,   if: :validate_password?
  validate :member

  has_and_belongs_to_many :roles

  def member
    errors.messages[:email] << " does not exist in the membership database" if self.person.nil? && !self.role?('Admin')
  end
  
  # 'password' is a virtual attribute
  def password
    @password
  end

  def password=(pwd)
    @password = pwd
    return if pwd.blank?
    create_new_salt
    self.hashed_password = encrypt(@password)
  end

  def get_confirmation_hash
    if self.confirmation_hash.nil?
      self.confirmation_hash = Digest::SHA256.hexdigest(self.email + Time.now.to_s)
      save(validate: false)
    end
    self.confirmation_hash
  end

  #Return true if user has the given role
  def role?(role)
    roles.find_by_name(role)? true : false
  end

  #Return true if user has at least one of the given roles
  def roles?(roles) 
    #array intersect
    not (self.roles.map {|r| r.name} & roles).empty?
  end

  def set_roles(current_user, role_ids)
    if current_user and current_user.role?('Admin')
      self.role_ids = role_ids
    else
      self.roles << Role.find_by_name('Member')
      self.person = Person.find_by_EmailAddress(self.email)
    end
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 3.months
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(validate: false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(validate: false)
  end

  def membership
    Person.find_by_EmailAddress(self.email).membership.id
  end
  
  private

  def self.authenticate(email, password)
    return nil if email.nil?
    user = User.find_by_email(email)
    if user and user.email_confirmed and
        user.hashed_password == User.encrypted_password(password,user.salt)
      user
    else
      nil
    end
  end

  # Assert whether or not the password validations should be performed. Always on new records, only on existing
  # records if the .password attribute isn't blank.
  def validate_password?
    self.new_record? ? true : !self.password.blank?
  end

  # Encrypts the string the user salt
  def encrypt(password)
    self.class.encrypted_password(password,salt)
  end

  def self.encrypted_password(password, salt)
    string_to_hash = password + "wobble" + salt
    Digest::SHA1.hexdigest(string_to_hash)
  end

  def create_new_salt
    self.salt = self.object_id.to_s + rand.to_s
  end

end

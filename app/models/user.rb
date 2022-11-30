require 'digest/sha1'

class User < ApplicationRecord

  attr_accessor :current_password
  has_secure_password
  has_many :active_sessions, dependent: :destroy
  before_save :downcase_email
  
  belongs_to :person, optional: true

  validates :email, format: {with: URI::MailTo::EMAIL_REGEXP}, presence: true, uniqueness: true
  validates_presence_of     :firstname, :lastname
  validates_length_of       :password, minimum: 6,    if: :validate_password?

  has_and_belongs_to_many :roles

  def member
    errors.messages[:email] << " does not exist in the membership database" if self.person.nil? && !self.role?('Admin')
  end

  def admin?
    role?('Admin')
  end
  
  def self.authenticate_by(attributes)
    passwords, identifiers = attributes.to_h.partition do |name, value|
      !has_attribute?(name) && has_attribute?("#{name}_digest")
    end.map(&:to_h)
    
    raise ArgumentError, "One or more password arguments are required" if passwords.empty?
    raise ArgumentError, "One or more finder arguments are required" if identifiers.empty?
    if (record = find_by(identifiers))
      record if passwords.count { |name, value| record.public_send(:"authenticate_#{name}", value) } == passwords.size
    else
      new(passwords)
      nil
    end
  end
  
  def confirm!
    if unconfirmed?
      update_columns(confirmed_at: Time.current)
    else
      false
    end
  end
  
  def confirmed?
    confirmed_at.present?
  end
  
  def unconfirmed?
    !confirmed?
  end
  
  def generate_confirmation_token
    signed_id expires_in: 1.hour, purpose: :confirm_email
  end
  
  def generate_password_reset_token
    signed_id expires_in: 1.hour, purpose: :reset_password
  end

  def send_confirmation_email!
    confirmation_token = generate_confirmation_token
    MailRobot.confirmation(self, confirmation_token).deliver_now
  end

  def send_password_reset_email!
    password_reset_token = generate_password_reset_token
    MailRobot.password_reset(self, password_reset_token).deliver_now
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

  def membership
    Person.find_by_EmailAddress(self.email).membership.id
  end
  
  private

  def downcase_email
    self.email = email.downcase
  end
  
  # Assert whether or not the password validations should be performed. Always on new records, only on existing
  # records if the .password attribute isn't blank.
  def validate_password?
    self.new_record? ? true : !self.password.blank?
  end

end

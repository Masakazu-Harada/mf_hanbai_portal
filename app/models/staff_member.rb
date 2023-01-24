class StaffMember < ApplicationRecord
  has_many :events, class_name: "StaffEvent", dependent: :destroy #:staff_eventsではなく:eventsにした理由はメソッド名を短くしたかったとの事

  def password=(raw_password)
    if raw_password.kind_of?(String)
      self.hashed_password = BCrypt::Password.create(raw_password)
    elsif raw_password.nil?
      self.hashed_password = nil
    end
  end

  def active?
    !self.suspended? &&
    self.start_date <= Date.today &&
    (self.end_date.nil? || self.end_date > Date.today)
  end
end

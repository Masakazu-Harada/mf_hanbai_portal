class StaffEvent < ApplicationRecord
  self.inheritance_column = nil

  belongs_to :member, class_name: "StaffMember", foreign_key: "staff_member_id"
  alias_attribute :occurred_at, :created_at

  enum status: { logged_in: 0, logged_out: 1, rejected: 2 }

  DESCRIPTIONS = {
    logged_in: "ログイン",
    logged_out: "ログアウト",
    rejected: "ログイン拒否"
  }

  def description
    DESCRIPTIONS[type.to_sym]
  end
end

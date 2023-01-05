class StaffMember < ApplicationRecord
  has_many :events, class_name: "StaffEvent", dependent: :destroy #:staff_eventsではなく:eventsにした理由はメソッド名を短くしたかったとの事

  KATAKANA_REGEXP = /\A[\p{katakana}\u{30fc}]+\z/ #全角カタカナと長棒(長音符)の正規表現を定数のKATAKANA_REGEPへ代入

  validates :family_name, :given_name, presence: true #苗字と名前の空欄をはじく
  validates :family_name_kana, :given_name_kana, presence: true, #フリガナの空欄をはじく
    format: { with: KATAKANA_REGEXP, allow_blank: true } #正規表現にマッチするかどうかを調べるformatバリデーション。withオプションで正規表現を指定する。 allow_blankオプションをtrueにすると値が空の場合バリデーションをスキップする。

  def password=(raw_password)
    if raw_password.kind_of?(String)
      self.hashed_password = BCrypt::Password.create(raw_password)
    elsif raw_password.nil?
      self.hashed_password = nil
    end
  end

  def active?
    !suspended? && start_date <= Date.today &&
      (end_date.nil? || end_date > Date.today)
  end
end

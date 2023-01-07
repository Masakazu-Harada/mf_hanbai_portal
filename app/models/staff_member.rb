class StaffMember < ApplicationRecord
  include StringNormalizer
    
    has_many :events, class_name: "StaffEvent", dependent: :destroy #:staff_eventsではなく:eventsにした理由はメソッド名を短くしたかったとの事
  
  before_validation do
    self.email = normalize_as_email(email)
    self.family_name = normalize_as_name(family_name)
    self.given_name = normalize_as_name(given_name)
    self.family_name_kana = normalize_as_furigana(family_name_kana)
    self.given_name_kana = normalize_as_furigana(given_name_kana)
  end
  
  KATAKANA_REGEXP = /\A[\p{katakana}\u{30fc}]+\z/ #全角カタカナと長棒(長音符)の正規表現を定数のKATAKANA_REGEPへ代入
  
  validates :email, presence: true, "valid_email_2/email": ture
    uniqueness: { case_sensitive: false }
  validates :family_name, :given_name, presence: true #苗字と名前の空欄をはじく
  validates :family_name_kana, :given_name_kana, presence: true, #フリガナの空欄をはじく
    format: { with: KATAKANA_REGEXP, allow_blank: true } #正規表現にマッチするかどうかを調べるformatバリデーション。withオプションで正規表現を指定する。 allow_blankオプションをtrueにすると値が空の場合バリデーションをスキップする。
  validates :start_date, presence: true, date: {
    after_or_equal_to: Date.new(2000, 1, 1), #after_or_equal_toで指定した日付以降のみ許可、before_or_equal_toで現在の日付以降のみ許可
    before: -> (obj) { 1.year.from_now.to_date } #2000年1月1日以降で且つ今日から1年後の日付より前, 1.year.from_nowはRails独特の日時記法で現在の時刻から一年後を返す。
  }
  validates :end_date, date: { #退職日のバリデーション
    after: :start_date, #入社日よりも後で
    before: -> (obj) { 1.year.from_now.to_date},
    allow_blank:true #allow_blank trueを指定すれば空欄が許可される つまり退職日は空欄で良い
  }
  
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

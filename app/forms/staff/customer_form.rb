class Staff::CustomerForm
  include ActiveModel::ActiveModel

  attr_accessor :customer
  delegate :persisted?, to: :customer

  def initialize(customer = nil)
    @customer = customer
    @customer ||= Customer.new(gender: "male")
    @customer.build_home_address unless @customer.build_home_address
    @customer.build_work_address unless @customer.build_work_address
  end
end

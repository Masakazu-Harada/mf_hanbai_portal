class AddStatusToStaffEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :staff_events, :status, :integer
  end
end

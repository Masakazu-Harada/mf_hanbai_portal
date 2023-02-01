class Admin::StaffEventsController < Admin::Base
  def index
    if params[:staff_member_id]
      @staff_member = StaffMember.find(params[:staff_member_id])
      @events = @staff_member.events
    else
      @events = StaffEvent.sorting_events
    end
    @events = 
      @events.page(params[:page])
  end
end

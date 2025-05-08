# Generates a structured calendar representation for a user's time allocations
# during a specified month. The calendar follows these rules:
#
# - Each week starts on Sunday and ends on Saturday
# - Only days from the specified month are included in the output
# - May also include days from the previous or next month if they fall within the week
# - Days are grouped by status: "confirmed" (has allocations) or "missed" (no allocations)
# - Groups are broken when status changes (e.g., from confirmed to missed)
# - All days of the month are represented in the output
class CalendarService
  def initialize(user, year, month)
    @user = user
    @year = year
    @month = month
    @start_date = Date.new(@year, @month, 1)
    @end_date = @start_date.end_of_month
  end

  def generate_calendar
    time_allocations = fetch_time_allocations
    allocation_by_date = map_allocations_by_date(time_allocations)

    calendar = []
    week_ranges = calculate_week_ranges

    week_ranges.each do |week_dates|
      week = create_week(week_dates, allocation_by_date)
      calendar << week if week[:groups].any?
    end

    calendar
  end

  private

  def calculate_week_ranges
    first_week_start = @start_date.beginning_of_week(:sunday)
    last_week_end = @end_date.end_of_week(:saturday)
    (first_week_start..last_week_end).to_a.each_slice(7)
  end

  def create_week(week_dates, allocation_by_date)
    week_start = week_dates.first
    week_end = week_dates.last

    week = {
      start_date: week_start,
      end_date: week_end,
      groups: []
    }

    month_dates = week_dates.select { |date| date.month == @month && date.year == @year }
    return week if month_dates.empty?

    create_groups_for_week(week, month_dates, allocation_by_date)
    week
  end

  def create_groups_for_week(week, month_dates, allocation_by_date)
    current_status = nil
    current_group = nil

    month_dates.each do |date|
      has_allocation = allocation_by_date.key?(date)
      status = has_allocation ? 'confirmed' : 'missed'

      if current_status != status || current_group.nil?
        week[:groups] << current_group if current_group

        current_group = create_group(status, date)
        current_status = status
      else
        current_group[:end_date] = date
      end

      day = create_day(date, allocation_by_date[date] || [])
      current_group[:days] << day
    end

    week[:groups] << current_group if current_group
  end

  def create_group(status, date)
    {
      status: status,
      start_date: date,
      end_date: date,
      days: []
    }
  end

  def create_day(date, allocations)
    {
      date: date,
      allocations: serialize_allocations(allocations)
    }
  end

  def serialize_allocations(allocations)
    ActiveModelSerializers::SerializableResource.new(
      allocations,
      each_serializer: Api::V1::TimeAllocationSerializer
    ).as_json
  end

  def fetch_time_allocations
    @user.time_allocations.where(date: @start_date..@end_date).order(date: :asc)
  end

  def map_allocations_by_date(time_allocations)
    allocation_by_date = {}
    time_allocations.each do |allocation|
      date_key = allocation.date.to_date
      allocation_by_date[date_key] ||= []
      allocation_by_date[date_key] << allocation
    end
    allocation_by_date
  end
end

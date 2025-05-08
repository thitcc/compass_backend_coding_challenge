# == Schema Information
#
# Table name: time_allocations
#
#  id          :integer          not null, primary key
#  activity    :string
#  date        :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  location_id :integer          not null
#  user_id     :integer          not null
#
# Indexes
#
#  index_time_allocations_on_location_id  (location_id)
#  index_time_allocations_on_user_id      (user_id)
#
# Foreign Keys
#
#  location_id  (location_id => locations.id)
#  user_id      (user_id => users.id)
#
class TimeAllocation < ApplicationRecord
  belongs_to :user
  belongs_to :location

  def formatted_date
    date&.strftime('%Y-%m-%d')
  end
end

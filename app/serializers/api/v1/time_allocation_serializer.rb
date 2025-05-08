class Api::V1::TimeAllocationSerializer < ActiveModel::Serializer
  attributes :location, :activity, :date, :weekday

  def location
    object.location&.name
  end

  def date
    object.formatted_date
  end

  def weekday
    object.date.strftime('%A')[0,3].upcase
  end
end

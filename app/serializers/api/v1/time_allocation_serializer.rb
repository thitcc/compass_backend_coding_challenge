class Api::V1::TimeAllocationSerializer < ActiveModel::Serializer
  attributes :location, :activity, :date

  def location
    object.location&.name
  end

  def date
    object.formatted_date
  end
end

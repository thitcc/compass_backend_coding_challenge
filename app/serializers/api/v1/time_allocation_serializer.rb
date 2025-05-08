class Api::V1::TimeAllocationSerializer < ActiveModel::Serializer
  attributes :user_id, :location, :activity, :date

  def location
    object.location&.name
  end

  def date
    object.date.strftime('%Y-%m-%d')
  end
end

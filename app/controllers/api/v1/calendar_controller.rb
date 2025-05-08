class Api::V1::CalendarController < Api::V1::BaseController
  before_action :set_user, only: [:index, :create]
  before_action :validate_date_params, only: [:index]

  # GET /api/v1/users/:user_id/calendar?year=2023&month=4
  def index
    start_date = Date.new(@year, @month, 1)
    end_date = start_date.end_of_month

    time_allocations = @user.time_allocations.where(date: start_date..end_date)

    render json: time_allocations, each_serializer: Api::V1::TimeAllocationSerializer
  end

  def create
    render json: {'test': 'create'}
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def validate_date_params
    @year = params[:year].to_i
    @month = params[:month].to_i

    if @year.zero? || @month.zero? || !valid_date?(@year, @month)
      render json: { error: 'Valid year and month must be provided' }, status: :bad_request
    end
  end

  def valid_date?(year, month)
    month.between?(1, 12) && year.positive?
  end
end

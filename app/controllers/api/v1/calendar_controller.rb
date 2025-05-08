class Api::V1::CalendarController < Api::V1::BaseController
  before_action :set_user, only: [:index, :create]
  before_action :validate_date_params, only: [:index]
  before_action :set_calendar_data, only: [:index]

  # GET /api/v1/users/:user_id/calendar?year=2023&month=4
  def index
    render json: { calendar: @calendar_data }
  end

  def create
    render json: {'test': 'create'}
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_calendar_data
    @calendar_data = CalendarService.new(@user, @year, @month).generate_calendar
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

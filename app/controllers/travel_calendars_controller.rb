class TravelCalendarsController < ApplicationController
  before_action :set_travel_calendar, only: [:show, :edit, :update, :destroy]

  # GET /travel_calendars
  # GET /travel_calendars.json
 def index
    @year_round_locations = Location.year_round_locations

    @current_month = Month.current_month
    @current_month_locations = Month.current_month_locations
    
    @best = Month.best
    @best_months = @best.map(&:name)
    
    @max_count =  Month.max_count

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_travel_calendar
      @travel_calendar = TravelCalendar.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def travel_calendar_params
      params.require(:travel_calendar).permit(:location_id, :month_id)
    end
end

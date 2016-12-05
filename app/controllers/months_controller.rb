class MonthsController < ApplicationController
	
	def index
		@month_locations_paginated = Month.locations_for_every_month.multi_month_filter(params[:ids]).paginate(page: params[:page], :per_page => 20)

		@names = Month.all.map(&:name)

		@multi_months = Month.all
	end


	def summary
		@months = Month.multi_month_filter(params[:ids])

		@multi_months = Month.all
	
		@unique_months = Month.unique_destination
	end

end
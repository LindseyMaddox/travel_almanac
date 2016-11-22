class MonthsController < ApplicationController
	
	before_filter :common_content, :only => [:index, :show]

	def index
		@month_locations_paginated = Month.locations_for_every_month.multi_month_filter(params[:ids]).paginate(page: params[:page], :per_page => 20)

		@names = Month.all.map(&:name)
	end


	def summary
		@months = Month.multi_month_filter(params[:ids])

		@unique_months = Month.unique_destination
	end

	private
	
	def common_content
    	@multi_months = Month.all
  	end
end
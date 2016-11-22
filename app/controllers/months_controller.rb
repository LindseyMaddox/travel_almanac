class MonthsController < ApplicationController
	def index
		@month_locations_paginated = Month.locations_for_every_month.month_filter(params[:month_filter]).paginate(page: params[:page], :per_page => 20)
		Month.select("months.id, months.name as m_name, locations.id, locations.name as l_name, locations.country as l_country, locations.region as l_region").joins(:locations).order("months.id asc, locations.name asc").paginate(page: params[:page], :per_page => 15)

		@names = Month.all.map(&:name)
	end


	def summary

		#@months = Month.multi_month_filter.params[:ids]
		if params[:ids].present?
			@months = Month.where('id IN (?)', params[:ids]) 
		else
			@months = Month.all
		end

		@multi_months = Month.all
		@names = Month.all.map(&:name)

		@unique_months = Month.unique_destination
	end

end
class Month < ActiveRecord::Base
	has_many :travel_calendars
	has_many :locations, through: :travel_calendars

	scope :best, -> { all.group_by { |m| m.locations.count }.max.last }
	
	scope :multi_month_filter, -> (ids) {
		if ids.present?
			where('months.id IN (?)', ids) 
		else
			all
		end
	}
	scope :filter, ->(region) {joins(:locations).where('locations.reg = ?', region) if region.present?}
	
	scope :locations_for_every_month, -> { select("months.id, months.name as m_name, locations.id, locations.name as l_name, locations.country as l_country, locations.region as l_region").joins(:locations).order("months.id asc, locations.name asc") }

	#extra method may need later for refactoring other stuff
	def self.get_month_location_hash
		
    month_locations = self.locations_for_every_month

	@month_location_hash = {}
	
	month_list = Month.all.map {|m| [m.id, m.name] }.to_h

		month_list.each_pair do |month_id, month_name|
			temp_array = []
			month_locations.each do |m|
				if m[0] == month_id
					temp_array.push([m[1], m[2]])
				end
			end
			@month_location_hash[month_name] = temp_array
			#reset temp array after storing has info
			temp_array = []
		end

	@month_location_hash
end

	def self.max_count
		max_count = []
		best_hash = self.all.group_by { |m| m.locations.count }
   		
   		best_hash.keys.max
    end

    def self.current_month
    	date = Date.today
    	current_month = date.strftime("%B")
    end

    def self.current_month_locations
    	
    	current_month = self.current_month

    	current_month_id = self.select(:id).where(name: current_month).first 

    	current_month_locations = self.where(id: current_month_id).merge(self.locations_for_every_month)
  	
  		current_month_locations
  	end

#REVIEW THIS
	def self.unique_destination

	    locations = Location.joins(:months)

	    location_array = locations.map(&:name)

	    location_count = {}

	    location_array.each do |location|
	      location_count[location] = (location_count[location] || 0) + 1
	    end

	    unique_group = []

	    location_count.each do |location, value|
	      if value == location_count.values.min
	        unique_group.push(location)
	      end
	    end
#ok through here

#so in unique group we have the list of locations for which the # of months you can visit
#is equal to the minimum

	    @temp_array = []
	    @unique_months_array = []
	    
	    #sending unique group to another method
	    
	    @unique_locations_map = {}
	    
	    unique_group.map do |location|
	      locations = unique_map(location)
	    end

	    #still need to refactor this to be more direct
	    x = 0
	    while x < (@temp_array.length-1) 
	      @unique_locations_map[@temp_array[x]] = @temp_array[(x+1)] 
		  x +=2
	    end
	   
	    @unique_locations_map 

	    reverse_map = {}
	   
	    @unique_locations_map.each do |key,value|
			reverse_map[value] = key
		end

#probably should move this to another method	
		@unique_months = {}
		reverse_map.each do |key, value|
			x = 0
			while x < key.length
				if @unique_months.has_key?(key[x])
					@temp_hash = {}
					@temp_hash[key[x]] = value
					@unique_months.merge!(@temp_hash) { |key,v1,v2| [v1,v2]}
				else
					@unique_months[key[x]] = value
				end
				x +=1
			end
		end

		@unique_months
	end

#get the list of months that match the location
	def self.unique_map(location)

	  months = Month.joins(:locations).where("locations.name = ?", location)
	  
	  month_list = months.map(&:name)
	   
	  @temp_array.push(location)
	  @temp_array.push(month_list)

	end

end

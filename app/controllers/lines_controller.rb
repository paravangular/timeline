class LinesController < ApplicationController
	before_action :authenticate_user!

	# consider adding accepts_nested_attributes_for :calendar in model
	def index
		@lines = current_user.lines
	end

	def new
		@line = Line.new
		@calendars = current_user.calendars
	end

	def create
		@line = current_user.lines.new(line_params)

		respond_to do |format|
      if @line.save
        format.html { redirect_to @line, notice: 'Timeline was successfully created.' }
        format.json { render action: 'create', status: :created, location: @line }
        format.js   { render action: 'create', status: :created, location: @line }
      else
        format.json { render json: { model: 'line', error: @line.errors}, status: :unprocessable_entity }
        format.js { render json: { model: 'line', error: @line.errors}, status: :unprocessable_entity }
      end
		end
	end

	def show
		@line = Line.find(params[:id])
		@events = @line.events
		@arcs = @line.arcs
		@entities = @line.entities
		@tags = current_user.tags
		gon.tags = @tags.all.collect(&:name)
		# gon.events = events_jsonify(@events)

		respond_to do |format|
			format.html
			format.json { render json: events_jsonify(@events) }
		end
	end
  
	def destroy
		@line.destroy
	end

	private

		def line_params
			params.require(:line).permit(:name, :calendar_id)
		end

		# TODO security of interpolation?
		def events_jsonify(events)
			events.collect do |event|
				{ id: event.id,
					name: event.name,
					summary: event.summary,
					start_era: event.start_era,
					start_date: "#{event.start_date or 0}/#{event.start_month or 0}/#{event.start_year}",
					end_date: "#{event.end_date or 0}/#{event.end_month or 0}/#{event.end_year or event.start_year}",
					arcs: event.arcs,
					entities: event.entities }
			end.to_json
		end
		
end

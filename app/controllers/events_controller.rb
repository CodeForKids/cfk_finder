class EventsController < ApplicationController
  before_action :set_owner
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  skip_before_action :authenticate_user!, only: [:show, :index]
  before_action :authenticate_creation!, only: [:new, :create]
  before_action :authenticate_view!, only: [:edit, :update, :destroy]

  def index
    @events = @owner.events
  end

  def show
  end

  def new
    @event = @owner.events.new
    @event.address = @event.build_address
  end

  def create
    @event = @owner.events.new(event_params)
    respond_to do |format|
      if @event.save
        format.html { redirect_to [@owner, @event], notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: [@owner, @event] }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to [@owner, @event], notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: [@owner, @event] }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to [@owner, :events], notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def authenticate_creation!
    redirect_auth current_user.role unless %w(Tutor).include?(current_user.role_type)
  end

  def authenticate_view!
    redirect_auth current_user.role unless current_user.role == @event.owner
  end

  def set_event
    @event = Event.find(params[:id])
  end

  def set_owner
    klass = [Tutor].detect{|c| params["#{c.name.underscore}_id"]}
    @owner= klass.find(params["#{klass.name.underscore}_id"])
  end

  def event_params
    params.require(:event).permit(:name, :description, :spots_available, :materials_needed, :event_type, :price_cents, :price_currency, :tax_rate,
                                  address_attributes: [:address1, :address2, :city, :province, :postal_code, :country])
  end
end

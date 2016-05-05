class TicketsController < ApplicationController
  before_action :authenticate_user!
  # load_and_authorize_resource
  before_action :set_ticket, only: [:show, :edit, :update, :destroy, :assign]

  def charts
    @chart_data = []
    @ticket_type_data = []
    tickets_count = Ticket.all.count
    ["General" , "Payment" , "Technical" , "Others"].each do |p|
      @ticket_type_data << {:name => p ,:y => ("%.2f" % (Ticket.where(:ticket_type => p).count.to_f/tickets_count.to_f)).to_f , :tickets => Ticket.where(:ticket_type => p).count  }
    end
    User.with_role(:support_staff).each do |user|
      @chart_data << {:y => Ticket.where(:status => "Resolved" , :assignee_id => user.id).count, :name => user.name}
    end
    @support_staff = User.with_role(:support_staff).pluck(:name)
    @filter = Ticket.new( :to_date => Time.now.strftime("%m/%d/%Y") )
  end

  def filter_charts
    @chart_data = []
    s = DateTime.strptime(params[:ticket][:from_date], "%d/%m/%Y")
    e = DateTime.strptime(params[:ticket][:to_date], "%d/%m/%Y")
    @tickets = Ticket.where("created_at > ? AND created_at < ?", s, e + 23.hours + 59.minutes).order('created_at DESC')

    User.with_role(:support_staff).each do |user|
      @chart_data << {:y => @tickets.where(:status => "Resolved" , :assignee_id => user.id).count, :name => user.name}
    end

    @support_staff = User.with_role(:support_staff).pluck(:name)

    @filter = Ticket.new( :from_date => params[:ticket][:from_date] , :to_date => params[:ticket][:to_date] )
    render "tickets/charts"
  end

  def filter
    s = DateTime.strptime(params[:ticket][:from_date], "%d/%m/%Y")
    e = DateTime.strptime(params[:ticket][:to_date], "%d/%m/%Y")
    @tickets = Ticket.where("created_at > ? AND created_at < ?", s, e + 23.hours + 59.minutes).order('created_at DESC')

    @filter = Ticket.new( :from_date => params[:ticket][:from_date] , :to_date => params[:ticket][:to_date] )
    render "tickets/index"
  end
  # GET /tickets
  # GET /tickets.json
  def index
    if can? :manage, Ticket
      @tickets = Ticket.all
    else
      @tickets = current_user.tickets
    end
    @filter = Ticket.new( :to_date => Time.now.strftime("%d/%m/%Y") )
  end

  def assign
    if @ticket.update(ticket_params)
      redirect_to tickets_path ,:notice => "Ticket assigned successfully"
    else
      redirect_to tickets_path ,:notice => "Ticket assigning failed"
    end
  end

  # GET /tickets/1
  # GET /tickets/1.json
  def show
  end

  # GET /tickets/new
  def new
     require "browser"
 
  
     # browser = Browser.new("Some User Agent", accept_language: "en-us")
 
     if browser.firefox?
       browser_id = "Mozilla Firefox"
     elsif browser.chrome?
       browser_id = "Google Chrome"
     elsif browser.ie?
       browser_id = "Internet Explorer"
     elsif browser.safari?
       browser_id = "Safari"
     end
 
     if browser.platform.linux?
       platform = OperatingSystem.find_by_name("Linux")
     elsif browser.platform.windows?
       platform = OperatingSystem.find_by_name("Windows")
     elsif browser.platform.mac?
       platform = OperatingSystem.find_by_name("Mac")
     end
     browser.platform.mac?
     @ticket = Ticket.new(:browser_id => browser_id, :operating_system => platform)
     @support_staff = User.with_role(:support_staff )
  end

  # GET /tickets/1/edit
  def edit
  end

  # POST /tickets
  # POST /tickets.json
  def create
    @ticket = Ticket.new(ticket_params)

    respond_to do |format|
      if @ticket.save
        format.html { redirect_to @ticket, notice: 'Ticket was successfully created.' }
        format.json { render :show, status: :created, location: @ticket }
      else
        format.html { render :new }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tickets/1
  # PATCH/PUT /tickets/1.json
  def update
    respond_to do |format|
      if @ticket.update(ticket_params)
        format.html { redirect_to @ticket, notice: 'Ticket was successfully updated.' }
        format.json { render :show, status: :ok, location: @ticket }
      else
        format.html { render :edit }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tickets/1
  # DELETE /tickets/1.json
  def destroy
    @ticket.destroy
    respond_to do |format|
      format.html { redirect_to tickets_path, notice: 'Ticket was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_ticket
    @ticket = Ticket.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def ticket_params
    params.require(:ticket).permit(:user_id, :status, :assignee_id, :company, :course, :operating_system_id, :browser_id, :description, :ticket_type)
  end
end

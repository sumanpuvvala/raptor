class MembersController < ApplicationController
  before_action :set_member, only: [:show, :edit, :update, :destroy, :mark, :unmark]
  before_action :current_member, only: [:show, :edit, :new, :maintenance]

  layout 'standard'

  # GET /members
  # GET /members.json
  def index
    @streams = NamedList.where(list_name: 'stream').select(:entry_name).order(:entry_name)
    @programs = NamedList.where(list_name: 'program').select(:entry_name).order(:entry_name)
    @managers = Member.active().select(:manager).distinct().order(:manager)
    @titles = Member.active().select(:title).distinct().order(:title)
    
    @member_name = params[:member_name]
    @stream = params[:stream]
    @program = params[:program]
    @title = params[:title]
    @manager = params[:manager]

    @members = Member.where(nil).active()
    @members = @members.name_includes(@member_name) if params[:member_name].present?
    @members = @members.stream(@stream) if params[:stream].present?
    @members = @members.title(@title) if params[:title].present?
    @members = @members.manager(@manager) if params[:manager].present?
#    @members = @members.has_subscribed() if params[:has_subscribed].present?
    @members = @members.order(:name)

    @subscriptions = Subscription.subscription().joins(:course, :member)
    @subscriptions = @subscriptions.program(@program) if params[:program].present?

    @completed_subscriptions = @subscriptions.completion()
    @inprogress_subscriptions = @subscriptions.inprogress()

    @subscriptions = @subscriptions.group(:member_id).sum(:credits)
    @completed_subscriptions = @completed_subscriptions.group(:member_id).sum(:credits)
    @inprogress_subscriptions = @inprogress_subscriptions.group(:member_id).sum(:credits)

    @members.each do |m| 
      m.credits = @subscriptions[m.id]
      m.credits_earned = @completed_subscriptions[m.id]
      m.credits_inprogress = @inprogress_subscriptions[m.id]
    end

  end

  # GET /members/1
  # GET /members/1.json
  def show
    @teammembers = Teammember.where(member_id: params[:id]).includes(:team)
    @teams = Team.active().where(member_id: params[:id])

    @courses = Course.active().where(member_id: params[:id]).includes(:topic).order(:title) 
    @interests = Interest.where(member_id: params[:id]).includes(:topic)
    @programs = NamedList.where(list_name: 'program').select(:entry_name).order("id DESC")

    @subscriptions = Subscription.where(member_id: params[:id]).includes(:course).order("status DESC", :due)

    @subscriptions.each do |m| 
      m.credits = m.course.credits.present? ? m.course.credits : 0;
      if m.status == "Completed" or m.status == "Certified"
        m.complete = true
      elsif m.status == "Exempted" or m.status == "Dropped"
        m.ignore = true
      elsif m.due != nil && m.due < Date.today()
        m.overdue = true
      end
    end

 end

  def mark

    cookies[:member_name] = @member.name
    cookies[:member_id] = @member.id
  #  puts cookies[:member_id]

    redirect_to @member
  end

  def unmark

    cookies[:member_name] = nil
    cookies[:member_id] = nil

    redirect_to @member
  end

  # GET /members/dashboard
  def dashboard
    @newratings = Subscription.completion().where("rating is not null").includes(:course, :member).order("updated_at DESC").limit(5)
    @newcourses = Course.active().includes(:topic, :member).order("created_at DESC").limit(5)
    @members = Member.active().order("created_at DESC").limit(5)
  end

  # GET /members/new
  def new
    @member = Member.new

    @streams = NamedList.where(list_name: 'stream').select(:entry_name).order(:entry_name)
    @managers = Member.active().select(:manager).distinct().order(:manager)
  end

  # GET /members/1/edit
  def edit
    @streams = NamedList.where(list_name: 'stream').select(:entry_name).order(:entry_name)
    @managers = Member.active().select(:manager).distinct().order(:manager)
  end

  # POST /members
  # POST /members.json
  def create
    @member = Member.new(member_params)

    respond_to do |format|
      if @member.save!
        format.html { redirect_to @member, notice: 'Member was successfully created.' }
        format.json { render :show, status: :created, location: @member }
      else
        format.html { render :new }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /members/1
  # PATCH/PUT /members/1.json
  def update
    respond_to do |format|
      if @member.update!(member_params)
        format.html { redirect_to @member, notice: 'Member was successfully updated.' }
        format.json { render :show, status: :ok, location: @member }
      else
        format.html { render :edit }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /members/1
  # DELETE /members/1.json
  def destroy
    @member.destroy!
    respond_to do |format|
      format.html { redirect_to members_url, notice: 'Member was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_member
      @member = Member.find(params[:id])
    end

    def current_member
      if cookies[:member_id] != "" and cookies[:member_id] != nil
        @current_member = Member.find(cookies[:member_id])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def member_params
      params.require(:member).permit(:name, :title, :stream, :manager, :is_lead, :active)
    end
end

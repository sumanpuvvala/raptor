class MembersController < ApplicationController
  before_action :set_member, only: [:show, :edit, :update, :destroy]

  layout 'standard'

  # GET /members
  # GET /members.json
  def index
    @streams = NamedList.where(list_name: 'stream').select(:entry_name).order(:entry_name)
    @managers = Member.all.select(:manager).distinct().order(:manager)
    @titles = Member.all.select(:title).distinct().order(:title)
    
    @member_name = params[:member_name]
    @stream = params[:stream]
    @title = params[:title]
    @manager = params[:manager]

    @members = Member.where(nil)
    @members = @members.name_includes(@member_name) if params[:member_name].present?
    @members = @members.stream(@stream) if params[:stream].present?
    @members = @members.title(@title) if params[:title].present?
    @members = @members.manager(@manager) if params[:manager].present?
    @members = @members.order(:name)

    @subscriptions = Subscription.subscription()
    @subscriptions = @subscriptions.joins(:course, :member).group(:member_id).sum(:credits)

    @completed_subscriptions = Subscription.completion()
    @completed_subscriptions = @completed_subscriptions.joins(:course, :member).group(:member_id).sum(:credits)

    @members.each do |m| 
      m.credits = @subscriptions[m.id]
      m.credits_earned = @completed_subscriptions[m.id]
    end

#    cookies[:member_name] = 'Suman'
#    cookies[:member_id] = 218

  end

  # GET /members/1
  # GET /members/1.json
  def show
    @teammembers = Teammember.where(member_id: params[:id]).includes(:team)
    @courses = Course.where(member_id: params[:id]).includes(:topic).order(:title)
    @interests = Interest.where(member_id: params[:id])
    @subscriptions = Subscription.where(member_id: params[:id]).includes(:course)

    @total_credits = @subscriptions.joins(:course).sum(:credits)
    @completed_credits = @subscriptions.completion().joins(:course).sum(:credits)

  end

  # GET /members/new
  def new
    @member = Member.new

    @streams = NamedList.where(list_name: 'stream').select(:entry_name).order(:entry_name)
    @managers = Member.all.select(:manager).distinct().order(:manager)
  end

  # GET /members/1/edit
  def edit
    @streams = NamedList.where(list_name: 'stream').select(:entry_name).order(:entry_name)
    @managers = Member.all.select(:manager).distinct().order(:manager)
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

    # Never trust parameters from the scary internet, only allow the white list through.
    def member_params
      params.require(:member).permit(:name, :title, :stream, :manager, :is_lead)
    end
end

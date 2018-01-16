class SubscriptionsController < ApplicationController
  before_action :set_subscription, only: [:show, :edit, :update, :destroy]
  before_action :current_member, only: [:show, :new, :edit]

  layout 'standard'

  # GET /subscriptions
  # GET /subscriptions.json
  def index
    @subscriptions = Subscription.where(nil)

    @courses = Course.active().order(:title)
    @members = Member.active().order(:name)
    @statuses = NamedList.where(list_name: 'status').select(:entry_name).order(:entry_name)
    @programs = NamedList.where(list_name: 'program').select(:entry_name).order(:entry_name)

    @course_id = params[:course_id]
    @member_id = params[:member_id]
#    @member_id = cookies[:member_id]

    @status = params[:status]
    @program = params[:program]

    @subscriptions = @subscriptions.member(@member_id) if @member_id.present?
    @subscriptions = @subscriptions.course(@course_id) if params[:course_id].present?
    @subscriptions = @subscriptions.status(@status) if params[:status].present?
    @subscriptions = @subscriptions.program(@program) if params[:program].present?
    @subscriptions = @subscriptions.includes(:member, :course)
  end

  # GET /subscriptions/1
  # GET /subscriptions/1.json
  def show
  end

  # GET /subscriptions/new
  def new
    @subscription = Subscription.new
    @subscription.program = 'Default' 

    if params[:course_id] != nil
      @subscription.course_id = params[:course_id] 
      @course = Course.find(@subscription.course_id)
    else
      @courses = Course.active().order(:title) 
    end

    if cookies[:member_id] != ""
      @subscription.member_id = cookies[:member_id] 
    else
      @subscription.member_id = params[:member_id] 
    end

    if @subscription.member_id != nil
      @member = Member.find(@subscription.member_id) 
    else
      @members = Member.active().order(:name) 
    end
    
    @statuses = NamedList.where(list_name: 'status').select(:entry_name).order(:entry_name)
    @programs = NamedList.where(list_name: 'program').select(:entry_name).order(:entry_name)
  end

  # GET /subscriptions/1/edit
  def edit
    @course = Course.find(@subscription.course_id)
    @member = Member.find(@subscription.member_id) 
    @statuses = NamedList.where(list_name: 'status').select(:entry_name).order(:entry_name)
    @programs = NamedList.where(list_name: 'program').select(:entry_name).order(:entry_name)
  end

  # POST /subscriptions
  # POST /subscriptions.json
  def create
    @subscription = Subscription.new(subscription_params)

    if params[:program] = nil
      @subscription.program = 'Default'
    end

    if @subscription.course.course_type == 'Training'
      @course_links = CourseLink.where(course_id: @subscription.course.id)

      @course_links.each do |c| 
        @child_course = Course.find(c.child_course_id)
        @child_subscription = Subscription.new(subscription_params)
        @child_subscription.course_id = @child_course.id
        @child_subscription.save

        logger.debug 'subscribed to ' + @child_course.title
      end
    end

    respond_to do |format|
      if @subscription.save
        format.html { redirect_to @subscription.member, notice: 'Subscription was successfully created.' }
        format.json { render :show, status: :created, location: @subscription }
      else
        format.html { render :new }
        format.json { render json: @subscription.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /subscriptions/1
  # PATCH/PUT /subscriptions/1.json
  def update
    respond_to do |format|
      if @subscription.update(subscription_params)
        format.html { redirect_to @subscription.member, notice: 'Subscription was successfully updated.' }
        format.json { render :show, status: :ok, location: @subscription }
      else
        format.html { render :edit }
        format.json { render json: @subscription.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subscriptions/1
  # DELETE /subscriptions/1.json
  def destroy
    @subscription.destroy
    respond_to do |format|
      format.html { redirect_to @subscription.member, notice: 'Subscription was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subscription
      @subscription = Subscription.find(params[:id])
    end

    def current_member
      if cookies[:member_id] != "" and cookies[:member_id] != nil
        @current_member = Member.find(cookies[:member_id])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def subscription_params
      params.require(:subscription).permit(:course_id, :member_id, :status, :rating, :comment, :due, :program)
    end

end

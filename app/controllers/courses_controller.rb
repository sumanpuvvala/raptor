class CoursesController < ApplicationController
  before_action :set_course, only: [:show, :edit, :update, :destroy, :copy]

  layout 'standard'
  
  # GET /courses
  # GET /courses.json
  def index
    @courses = Course.where(nil)

    @topics = Topic.all.order(:name)
    @members = Member.all.order(:name)
    @difficulties = NamedList.where(list_name: 'difficulty').select(:entry_name).order(:entry_name)
    @course_types = NamedList.where(list_name: 'course_type').select(:entry_name).order(:entry_name)

    @course_name = params[:course_name]
    @topic_id = params[:topic_id]
    @member_id = params[:member_id]
    @difficulty = params[:difficulty]
    @course_type = params[:course_type]

    @courses = @courses.name_includes(@course_name) if params[:course_name].present?
    @courses = @courses.topic(@topic_id) if params[:topic_id].present?
    @courses = @courses.contributor(@member_id) if params[:member_id].present?
    @courses = @courses.difficulty(@difficulty) if params[:difficulty].present?
    @courses = @courses.course_type(@course_type) if params[:course_type].present?
    @courses = @courses.includes(:topic, :member).order(:title)

    @subscriptions = Subscription.completion().group(:course_id).average(:rating)

    @courses.each do |c| 
      c.rating = @subscriptions[c.id]
    end

  end

  # GET /courses/1
  # GET /courses/1.json
  def show
    @subscriptions = Subscription.where(course_id: params[:id]).includes(:member)
    @average = @subscriptions.completion().average(:rating)
    if @average == nil
      @average = 0.0
    end
    
  end

  # GET /courses/new
  def new
    @course = Course.new
    @course.topic_id = params[:topic_id]
    @course.member_id = params[:member_id]

    @topics = Topic.all.order(:name)
    @difficulties = NamedList.where(list_name: 'difficulty').select(:entry_name).order(:entry_name)
    @course_types = NamedList.where(list_name: 'course_type').select(:entry_name).order(:entry_name)
    @members = Member.all.order(:name)
  end

  # GET /courses/1/edit
  def edit
    @topics = Topic.all.order(:name)
    @difficulties = NamedList.where(list_name: 'difficulty').select(:entry_name).order(:entry_name)
    @course_types = NamedList.where(list_name: 'course_type').select(:entry_name).order(:entry_name)
    @members = Member.all.order(:name)
  end

  # POST /courses
  # POST /courses.json
  def create
    @course = Course.new(course_params)

    respond_to do |format|
      logger.debug 'Saving Course ' + @course.title + ": #{@course.valid?}"
      if @course.save!
        format.html { redirect_to @course, notice: 'Course was successfully created.' }
        format.json { render :show, status: :created, location: @course }
      else
        logger.debug @course.errors.full_messages
        format.html { render :new }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /courses
  # POST /courses.json
  def copy
    @course2 = @course.dup
    @course2.title = @course2.title + ' (Copy)'

    respond_to do |format|
      logger.debug 'Saving Course ' + @course2.title + ": #{@course2.valid?}"
      logger.debug @course2.id
      if @course2.save!
        format.html { redirect_to @course2, notice: 'Course was successfully copied.' }
        format.json { render :show, status: :created, location: @course2 }
      else
        logger.debug @course2.errors.full_messages
        format.html { render :new }
        format.json { render json: @course2.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses/1
  # PATCH/PUT /courses/1.json
  def update
    respond_to do |format|
      logger.debug 'Saving Course ' + @course.title + ": #{@course.valid?}"
      if @course.update!(course_params)
        format.html { redirect_to @course, notice: 'Course was successfully updated.' }
        format.json { render :show, status: :ok, location: @course }
      else
        logger.debug @course.errors.full_messages
        format.html { render :edit }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    @course.destroy
    respond_to do |format|
      format.html { redirect_to courses_url, notice: 'Course was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def course_params
      params.require(:course).permit(:title, :details, :topic_id, :course_type, :time_estimate, :difficulty, :cost_course, :cost_certification, :member_id, :credits, :university, :url)
    end
end

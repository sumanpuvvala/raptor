class CourseLinksController < ApplicationController
  before_action :set_course_link, only: [:show, :edit, :update, :destroy]

  layout 'standard'

  # GET /course_links
  # GET /course_links.json
  def index
    @course_links = CourseLink.all
  end

  # GET /course_links/1
  # GET /course_links/1.json
  def show
  end

  # GET /course_links/new
  def new
    @course_link = CourseLink.new
    @course_link.course_id = params[:course_id]
    @course_link.child_course_id = params[:child_course_id]

    @course = Course.find(params[:course_id])

#    @courses = Course.all.order(:title)
    @courses = Course.where(nil)
    @courses = @courses.topic(@course.topic_id) if params[:course_id].present?
    @courses = @courses.includes(:topic, :member).order(:title)
  end

  # GET /course_links/1/edit
  def edit
  end

  # POST /course_links
  # POST /course_links.json
  def create
    @course_link = CourseLink.new(course_link_params)

    logger.debug @course_link.to_yaml
 
#    @course = Course.find(id: @course_link.course_id)
#    @child_course = Course.find(id: @course_link.child_course_id)

    respond_to do |format|
      if @course_link.save!
        format.html { redirect_to @course_link.course, notice: 'Course link was successfully created.' }
        format.json { render :show, status: :created, location: @course_link }
      else
        format.html { render :new }
        format.json { render json: @course_link.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /course_links/1
  # PATCH/PUT /course_links/1.json
  def update
    respond_to do |format|
      if @course_link.update!(course_link_params)
        format.html { redirect_to @course_link.course, notice: 'Course link was successfully updated.' }
        format.json { render :show, status: :ok, location: @course_link }
      else
        format.html { render :edit }
        format.json { render json: @course_link.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /course_links/1
  # DELETE /course_links/1.json
  def destroy
    @course_link.destroy!
    respond_to do |format|
      format.html { redirect_to @course_link.course, notice: 'Course link was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course_link
      @course_link = CourseLink.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def course_link_params
      params.require(:course_link).permit(:course_id, :child_course_id, :link_type)
    end
end

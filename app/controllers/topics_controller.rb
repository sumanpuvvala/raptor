class TopicsController < ApplicationController
  before_action :current_member, only: [:edit]

layout 'standard'

  before_action :set_topic, only: [:show, :edit, :update, :destroy]


  # GET /topics
  # GET /topics.json
  def index
    @topics = Topic.where(nil)

    @categories = Category.active().order(:name)
    @classifications = Classification.active().order(:name)
    @teams = Team.active().order(:name)

    @topic_name = params[:topic_name]
    @category_id = params[:category_id]
    @classification_id = params[:classification_id]
    @team_id = params[:team_id]
    #@sort_by = params[:sort_by]
    #if @sort_by == nil
    #  @sort_by = :name
    #end

    @topics = @topics.name_includes(@topic_name) if params[:topic_name].present?
    @topics = @topics.category(@category_id) if params[:category_id].present?
    @topics = @topics.classification(@classification_id) if params[:classification_id].present?
    @topics = @topics.team(@team_id) if params[:team_id].present?
    @topics = @topics.includes(:category, :classification, :team)
    @topics = @topics.active()
    @topics = @topics.order(:name)
  end

  # GET /topics/1
  # GET /topics/1.json
  def show
    @courses = Course.active().where(topic_id: params[:id]).includes(:member, :subscriptions)

    @interests = Interest.where(topic_id: params[:id])

    @subscriptions = Subscription.completion().group(:course_id).average(:rating)

    @courses.each do |c| 
      c.rating = @subscriptions[c.id]
    end
  end

  # GET /topics/new
  def new
    @topic = Topic.new
    
    @categories = Category.active().order(:name)
    @classifications = Classification.active().order(:name)
    @teams = Team.active().order(:name)

    @topic.category_id = params[:category_id]
    @topic.classification_id = params[:classification_id]
    @topic.team_id = params[:team_id]
  end

  # GET /topics/1/edit
  def edit
    @categories = Category.active().order(:name)
    @classifications = Classification.active().order(:name)
    @teams = Team.active().order(:name)
  end

  # POST /topics
  # POST /topics.json
  def create
    @topic = Topic.new(topic_params)
    @topic.active = true

    respond_to do |format|
      if @topic.save!
        format.html { redirect_to @topic, notice: 'Topic was successfully created.' }
        format.json { render :show, status: :created, location: @topic }
      else
        format.html { render :new }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /topics/1
  # PATCH/PUT /topics/1.json
  def update
    respond_to do |format|
      if @topic.update!(topic_params)
        format.html { redirect_to @topic, notice: 'Topic was successfully updated.' }
        format.json { render :show, status: :ok, location: @topic }
      else
        format.html { render :edit }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /topics/1
  # DELETE /topics/1.json
  def destroy
    @topic.destroy!
    respond_to do |format|
      format.html { redirect_to topics_url, notice: 'Topic was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_topic
      @topic = Topic.find(params[:id])
    end

    def current_member
      if cookies[:member_id] != "" and cookies[:member_id] != nil
        @current_member = Member.find(cookies[:member_id])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def topic_params
      params.require(:topic).permit(:name, :category_id, :classification_id, :team_id, :details, :active)
    end
end

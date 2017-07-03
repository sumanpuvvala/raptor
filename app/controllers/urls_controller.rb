class UrlsController < ApplicationController
  before_action :set_url, only: [:show, :edit, :update, :destroy]
  before_action :current_member, only: [:show, :edit, :new]

  layout 'standard'
  
  # GET /urls
  # GET /urls.json
  def index
    @urls = Url.all
  end

  # GET /urls/1
  # GET /urls/1.json
  def show
  end

  # GET /urls/new
  def new
    @url = Url.new

    @url.entity_id = params[:entity_id] if params[:entity_id].present?
    @url.entity = params[:entity] if params[:entity].present?

    if @url.entity == 'course'
      @course = Course.find(@url.entity_id)
      @url.entity_name = @course.title
    end

    @url_types = NamedList.where(list_name: 'course_type').select(:entry_name).order(:entry_name)
  end

  # GET /urls/1/edit
  def edit
    if @url.entity == 'course'
      @course = Course.find(@url.entity_id)
      @url.entity_name = @course.title
    end

    @url_types = NamedList.where(list_name: 'course_type').select(:entry_name).order(:entry_name)
  end

  # POST /urls
  # POST /urls.json
  def create
    @url = Url.new(url_params)

    respond_to do |format|
      if @url.save
        if @url.entity == 'course'
          @course = Course.find(@url.entity_id)
          format.html { redirect_to @course, notice: 'Url was successfully created.' }
          format.json { render :show, status: :created, location: @url }
        else
          format.html { redirect_to @url, notice: 'Url was successfully created.' }
          format.json { render :show, status: :created, location: @url }
        end
      else
        format.html { render :new }
        format.json { render json: @url.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /urls/1
  # PATCH/PUT /urls/1.json
  def update
    respond_to do |format|
      if @url.update(url_params)
        if @url.entity == 'course'
          @course = Course.find(@url.entity_id)
          format.html { redirect_to @course, notice: 'Url was successfully updated.' }
          format.json { render :show, status: :ok, location: @url }
        else
          format.html { redirect_to @url, notice: 'Url was successfully updated.' }
          format.json { render :show, status: :ok, location: @url }
        end
      else
        format.html { render :edit }
        format.json { render json: @url.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /urls/1
  # DELETE /urls/1.json
  def destroy
    @url.destroy
    respond_to do |format|
       if @url.entity == 'course'
          @course = Course.find(@url.entity_id)
          format.html { redirect_to @course, notice: 'Url was successfully destroyed.' }
          format.json { head :no_content }
        else
          format.html { redirect_to urls_url, notice: 'Url was successfully destroyed.' }
          format.json { head :no_content }
        end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_url
      @url = Url.find(params[:id])
    end

    def current_member
      if cookies[:member_id] != "" and cookies[:member_id] != nil
        @current_member = Member.find(cookies[:member_id])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def url_params
      params.require(:url).permit(:entity, :url, :url_type, :entity_id, :url_type, :details)
    end
end

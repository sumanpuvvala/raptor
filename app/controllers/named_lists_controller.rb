class NamedListsController < ApplicationController
  before_action :set_named_list, only: [:show, :edit, :update, :destroy]
  before_action :current_member, only: [:index]

  layout 'standard'

  # GET /named_lists
  # GET /named_lists.json
  def index
    @list_name = params[:list_name]

    @named_lists = NamedList.where(nil)
    @named_lists = @named_lists.list(@list_name) if params[:list_name].present?
    @named_lists = @named_lists.order(:list_name, :entry_name)

    @list_names = NamedList.all.select(:list_name).distinct.order(:list_name)
  end

  # GET /named_lists/1
  # GET /named_lists/1.json
  def show
  end

  # GET /named_lists/new
  def new
    @named_list = NamedList.new
  end

  # GET /named_lists/1/edit
  def edit
  end

  # POST /named_lists
  # POST /named_lists.json
  def create
    @named_list = NamedList.new(named_list_params)

    respond_to do |format|
      if @named_list.save!
        format.html { redirect_to named_lists_url, notice: 'Named list was successfully created.' }
        format.json { render :show, status: :created, location: @named_list }
      else
        format.html { render :new }
        format.json { render json: @named_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /named_lists/1
  # PATCH/PUT /named_lists/1.json
  def update
    respond_to do |format|
      if @named_list.update!(named_list_params)
        format.html { redirect_to @named_list, notice: 'Named list was successfully updated.' }
        format.json { render :show, status: :ok, location: @named_list }
      else
        format.html { render :edit }
        format.json { render json: @named_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /named_lists/1
  # DELETE /named_lists/1.json
  def destroy
    @named_list.destroy!
    respond_to do |format|
      format.html { redirect_to named_lists_url, notice: 'Named list was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_named_list
      @named_list = NamedList.find(params[:id])
    end

    def current_member
      if cookies[:member_id] != "" and cookies[:member_id] != nil
        @current_member = Member.find(cookies[:member_id])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def named_list_params
      params.require(:named_list).permit(:list_name, :entry_name)
    end
end

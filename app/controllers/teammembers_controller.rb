class TeammembersController < ApplicationController
  before_action :set_teammember, only: [:show, :edit, :update, :destroy]

  layout 'standard'

  # GET /teammembers
  # GET /teammembers.json
  def index
    @teammembers = Teammember.includes(:team, :member).order(:team_id)
  end

  # GET /teammembers/1
  # GET /teammembers/1.json
  def show
  end

  # GET /teammembers/new
  def new
    @teammember = Teammember.new
    @teams = Team.active().order(:name)
    @members = Member.active().order(:name)
    @teammember.team_id = params[:team_id]
    if cookies[:member_id] != ""
      @teammember.member_id = cookies[:member_id]
    else
      @teammember.member_id = params[:member_id]
    end

  end

  # GET /teammembers/1/edit
  def edit
    @teams = Team.active().order(:name)
    @members = Member.active().order(:name)
  end

  # POST /teammembers
  # POST /teammembers.json
  def create
    @teammember = Teammember.new(teammember_params)

    respond_to do |format|
      if @teammember.save!
        format.html { redirect_to @teammember.team, notice: 'Teammember was successfully created.' }
        format.json { render :show, status: :created, location: @teammember }
      else
        format.html { render :new }
        format.json { render json: @teammember.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teammembers/1
  # PATCH/PUT /teammembers/1.json
  def update
    respond_to do |format|
      if @teammember.update!(teammember_params)
        format.html { redirect_to @teammember.team, notice: 'Teammember was successfully updated.' }
        format.json { render :show, status: :ok, location: @teammember }
      else
        format.html { render :edit }
        format.json { render json: @teammember.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teammembers/1
  # DELETE /teammembers/1.json
  def destroy
    @teammember.destroy!
    respond_to do |format|
      format.html { redirect_to @teammember.team, notice: 'Teammember was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_teammember
      @teammember = Teammember.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def teammember_params
      params.require(:teammember).permit(:team_id, :member_id)
    end
end

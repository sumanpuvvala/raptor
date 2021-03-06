class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy]
  before_action :current_member, only: [:show, :edit]

  layout 'standard'

  # GET /teams
  # GET /teams.json
  def index
    @teams = Team.active().order(:name).includes(:member)
  end

  # GET /teams/1
  # GET /teams/1.json
  def show
#    @teams = Team.find(params[:id])
    @teammembers = Teammember.where(team_id: params[:id]).order(:team_id).includes(:member => {:subscriptions => :course})
    @topics = Topic.active().where(team_id: params[:id]).order(:name).includes(:category, :classification)

    @teammembers.each do |m|
      m.member.credits_earned = 0
      m.member.credits = 0
      m.member.subscriptions.each do |s|
        if s.course.credits != nil
          if (s.status == 'Completed' or s.status == 'Certified') 
            m.member.credits_earned += s.course.credits
          else
            m.member.credits += s.course.credits
          end
        end
      end
    end
  end

  # GET /teams/new
  def new
    @team = Team.new
    @members = Member.active().order(:name)
  end

  # GET /teams/1/edit
  def edit
    @members = Member.active().order(:name)
  end

  # POST /teams
  # POST /teams.json
  def create
    @team = Team.new(team_params)
    @team.active = true

    respond_to do |format|
      if @team.save
        format.html { redirect_to @team, notice: 'Team was successfully created.' }
        format.json { render :show, status: :created, location: @team }
      else
        format.html { render :new }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teams/1
  # PATCH/PUT /teams/1.json
  def update
    respond_to do |format|
      if @team.update(team_params)
        format.html { redirect_to @team, notice: 'Team was successfully updated.' }
        format.json { render :show, status: :ok, location: @team }
      else
        format.html { render :edit }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.json
  def destroy
    @team.destroy
    respond_to do |format|
      format.html { redirect_to teams_url, notice: 'Team was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.find(params[:id])
    end

    def current_member
      if cookies[:member_id] != "" and cookies[:member_id] != nil
        @current_member = Member.find(cookies[:member_id])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def team_params
      params.require(:team).permit(:name, :member_id, :purpose, :active)
    end
end

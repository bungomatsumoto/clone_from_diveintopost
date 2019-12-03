class TeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_team, only: %i[show edit update destroy delegate]

  def index
    @teams = Team.all
  end

  def show
    @working_team = @team
    change_keep_team(current_user, @team)
  end

  def new
    @team = Team.new
  end


  def create
    @team = Team.new(team_params)
    @team.owner = current_user
    if @team.save
      @team.invite_member(@team.owner)
      redirect_to @team, notice: ".t('views.messages.create_team"
    else
      flash.now[:error] = ".t('views.messages.failed_to_save_team"
      render :new
    end
  end

  def edit
    unless @team.owner == current_user
      flash.now[:error] = ".t('views.messages.cannot_edit_the_team"
      render :show
    end
  end

  def update
    if @team.update(team_params)
      redirect_to @team, notice: ".t('views.messages.update_team"
    else
      flash.now[:error] = ".t('views.messages.failed_to_save_team"
      render :edit
    end
  end

  def delegate
    @team.owner_id = params[:assigned_user_id]
    if @team.update(team_params)
      # binding.pry
      DelegateMailer.delegate_mail(@team.owner.email, @team.name).deliver
      # binding.pry
      redirect_to @team, notice: ".t('views.messages.delegate_team"
    else
      flash.now[:error] = ".t('views.messages.failed_to_save_team"
      render :edit
    end
  end

  def destroy
    @team.destroy
    redirect_to teams_url, notice: ".t('views.messages.delete_team"
  end

  def dashboard
    @team = current_user.keep_team_id ? Team.find(current_user.keep_team_id) : current_user.teams.first
  end

  private

  def set_team
    @team = Team.friendly.find(params[:id])
  end

  def team_params
    params.fetch(:team, {}).permit %i[name icon icon_cache owner_id keep_team_id]
  end
end

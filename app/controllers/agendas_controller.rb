class AgendasController < ApplicationController
  before_action :set_agenda, only: :destroy

  def index
    @agendas = Agenda.all
  end

  def new
    @team = Team.friendly.find(params[:team_id])
    @agenda = Agenda.new
  end

  def create
    @agenda = current_user.agendas.build(title: params[:title])
    @agenda.team = Team.friendly.find(params[:team_id])
    current_user.keep_team_id = @agenda.team.id
    if current_user.save && @agenda.save
      redirect_to dashboard_url, notice: I18n.t('views.messages.create_agenda')
    else
      render :new
    end
  end

  def destroy
    @team = @agenda.team
    if @team.owner == current_user || current_user.id == @agenda.user.id
      @team_email = @team.users.pluck(:email)
      @agenda.destroy
      DestroyNotifierMailer.destroy_notifier_mail(@team_email, @team.name, @agenda.title).deliver
      redirect_to dashboard_url, notice: I18n.t('views.messages.destroy_agenda')
    else
      redirect_to dashboard_url, notice: I18n.t('views.messages.cannot_destroy_agenda')
    end
  end

  private

  def set_agenda
    @agenda = Agenda.find(params[:id])
  end

  def agenda_params
    params.fetch(:agenda, {}).permit %i[title description]
  end
end

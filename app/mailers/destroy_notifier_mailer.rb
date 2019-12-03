class DestroyNotifierMailer < ApplicationMailer
  default from: 'from@example.com'

  def destroy_notifier_mail(email, team, agenda)
    @email = email
    @team = team
    @agenda = agenda
    mail to: @email, subject: I18n.t('views.messages.destroy_agenda')
  end
end

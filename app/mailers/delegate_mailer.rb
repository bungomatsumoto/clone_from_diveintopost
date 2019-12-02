class DelegateMailer < ApplicationMailer
  default from: 'from@example.com'

  def delegate_mail(email, team_name)
    # binding.pry
    @email = email
    @team = team_name
    mail to: @email, subject: I18n.t('views.messages.owner_is_delegated')
  end
end

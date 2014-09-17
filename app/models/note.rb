class Note < ActiveRecord::Base
  include SessionInfoModule

  belongs_to :physical_object

  validates :user, presence: true
  validates :physical_object, presence: true

  after_initialize :default_values

  def default_values
    self.user ||= (SessionInfoModule.session.nil? || SessionInfoModule.session[:username].nil? || SessionInfoModule.session[:username].blank?) ? "UNAVAILABLE" : SessionInfoModule.session[:username]
  end
end
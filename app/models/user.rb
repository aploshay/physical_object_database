class User < ActiveRecord::Base

  validates :name, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true

  default_scope { order(:name) }

  def self.authenticate(username)
    return false if username.nil? || username.blank?
    return true if valid_usernames.include? username
    return false
  end

  def self.valid_usernames
    return User.all.map { |user| user.username }
  end

  def self.current_user=(user)
    Thread.current[:current_user] = user
  end

  def self.current_user
    user_string = Thread.current[:current_user].to_s
    user_string.blank? ? "UNAVAILABLE" : user_string
  end

  def self.current_user_object
    Thread.current[:current_user]
  end

  def permit?(controller, action, record)
    permissions.map { |p| p[controller][action] }.any?
  end

  def permissions
    roles.map { |r| ROLE_PERMISSIONS[r] }
  end

  def roles
    [:all_access]
  end

  ROLES = [:nil_access, :all_access, :smart_user, :smart_admin, :qc_user, :qc_admin]

  NO_ACTIONS = {}
  ALL_ACTIONS = Hash.new(true)
  READ_ONLY = { index: true, show: true }
  EDIT_ONLY = { index: true, show: true, edit: true, update: true }
  ALL_BUT_DELETE = ALL_ACTIONS.merge({ destroy: false})

  NIL_ACCESS = Hash.new(NO_ACTIONS)
  ALL_ACCESS = Hash.new(ALL_ACTIONS)
  SMART_USER = NIL_ACCESS.merge({
    BatchesController => ALL_BUT_DELETE,
    BinsController => ALL_BUT_DELETE,
    BoxesController => ALL_BUT_DELETE,
    ConditionStatusTemplatesController => READ_ONLY,
    DigitalProvenanceController => NO_ACTIONS,
    DigitizationController => NO_ACTIONS,
    GroupKeysController => ALL_BUT_DELETE,
    InvoiceController => NO_ACTIONS,
    MachinesController => NO_ACTIONS,
    MessagesController => NO_ACTIONS,
    PhysicalObjectsController => ALL_BUT_DELETE,
    PicklistSpecificationsController => ALL_BUT_DELETE,
    PicklistsController => ALL_BUT_DELETE,
    ProcessingStepsController => NO_ACTIONS,
    QualityControlController => NO_ACTIONS,
    ReportsController => NO_ACTIONS,
    ReturnsController => ALL_ACTIONS,
    SearchController => ALL_ACTIONS,
    SignalChainsController => NO_ACTIONS,
    SpreadsheetsController => ALL_BUT_DELETE,
    StatusTemplatesController => READ_ONLY,
    UnitsController => READ_ONLY,
    UsersController => NO_ACTIONS,
    WorkflowStatusTemplatesController => READ_ONLY,
    XmlTesterController => NO_ACTIONS,
  })
  SMART_ADMIN = NIL_ACCESS.merge({
    BatchesController => ALL_ACTIONS,
    BinsController => ALL_ACTIONS,
    BoxesController => ALL_ACTIONS,
    ConditionStatusTemplatesController => READ_ONLY,
    DigitalProvenanceController => READ_ONLY,
    DigitizationController => NO_ACTIONS,
    GroupKeysController => ALL_ACTIONS,
    InvoiceController => ALL_ACTIONS,
    MachinesController => READ_ONLY,
    MessagesController => READ_ONLY,
    PhysicalObjectsController => ALL_ACTIONS,
    PicklistSpecificationsController => ALL_ACTIONS,
    PicklistsController => ALL_ACTIONS,
    ProcessingStepsController => READ_ONLY,
    QualityControlController => { index: true, staging_index: true },
    ReportsController => ALL_ACTIONS,
    ReturnsController => ALL_ACTIONS,
    SearchController => ALL_ACTIONS,
    SignalChainsController => READ_ONLY,
    SpreadsheetsController => ALL_ACTIONS,
    StatusTemplatesController => READ_ONLY,
    UnitsController => ALL_BUT_DELETE,
    UsersController => READ_ONLY,
    WorkflowStatusTemplatesController => READ_ONLY,
    XmlTesterController => NO_ACTIONS,
  })
  QC_USER = NIL_ACCESS.merge({
    BatchesController => READ_ONLY,
    BinsController => READ_ONLY,
    BoxesController => READ_ONLY,
    ConditionStatusTemplatesController => READ_ONLY,
    DigitalProvenanceController => ALL_BUT_DELETE,
    DigitizationController => NO_ACTIONS,
    GroupKeysController => READ_ONLY,
    InvoiceController => READ_ONLY,
    MachinesController => ALL_BUT_DELETE,
    MessagesController => ALL_BUT_DELETE,
    PhysicalObjectsController => READ_ONLY,
    PicklistSpecificationsController => READ_ONLY,
    PicklistsController => READ_ONLY,
    ProcessingStepsController => ALL_BUT_DELETE,
    QualityControlController => ALL_ACTIONS,
    ReportsController => ALL_ACTIONS,
    ReturnsController => NO_ACTIONS,
    SearchController => ALL_ACTIONS,
    SignalChainsController => ALL_BUT_DELETE,
    SpreadsheetsController => READ_ONLY,
    StatusTemplatesController => READ_ONLY,
    UnitsController => READ_ONLY,
    UsersController => NO_ACTIONS,
    WorkflowStatusTemplatesController => READ_ONLY,
    XmlTesterController => NO_ACTIONS,
  })
  QC_ADMIN = ALL_ACCESS.merge({
    ConditionStatusTemplatesController => READ_ONLY,
    StatusTemplatesController => READ_ONLY,
    UnitsController => READ_ONLY,
    UsersController => READ_ONLY,
    WorkflowStatusTemplatesController => READ_ONLY,
    XmlTesterController => NO_ACTIONS,
  })
  WEB_ADMIN = ALL_ACCESS.merge({
    ConditionStatusTemplatesController => READ_ONLY,
    StatusTemplatesController => READ_ONLY,
    WorkflowStatusTemplatesController => READ_ONLY,
  })

  ROLE_PERMISSIONS = {
    nil_access: NIL_ACCESS,
    all_access: ALL_ACCESS,
    smart_user: SMART_USER,
    smart_admin: SMART_ADMIN,
    qc_user: QC_USER,
    qc_admin: QC_ADMIN,
    web_admin: WEB_ADMIN,
  }
end

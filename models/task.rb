class Task
  include Mongoid::Document
  include Mongoid::Timestamps

  # fields
  field :description, type: String
  field :done,        type: Boolean, default: false
  field :due_date,    type: Time

  # validations
  validates_presence_of :description, :done


  # Returns whether this task is overdue or not
  def overdue?
    return false if due_date.nil?
    Time.now > due_date
  end

  class << self
    # Filter all tasks using defined scopes.
    # Receives a hash with key/value pairs containing the filter data.
    # Only supported filters will be evaluated.
    #
    # Example:
    #   {overdue: true, is_done: false}
    #
    # Will evaluate into:
    #   Task.overdue(true).is_done(false)
    def filter(attributes = {})
      return all if attributes.empty?
      supported_filters = [:overdue]
      attributes.slice(*supported_filters).inject(all) do |scope, (key, value)|
        value.present? ? scope.send(key, value) : scope
      end
    end
  end

  # Entity
  class Entity < Grape::Entity
    format_with(:simple_id) { |id| id.to_s }

    with_options format_with: :simple_id do
      expose :id,         documentation: { type: String,  desc: "The task ID." }
    end
    expose :description,  documentation: { type: String,  desc: "The task description." }
    expose :done,         documentation: { type: Boolean, desc: "Whether the task is completed or not." }

    # V2
    with_options if: { version: 'v2' } do
      expose :due_date,   documentation: { type: Time,    desc: "The task due date." }
      expose :overdue?,   documentation: { type: Boolean, desc: "Whether the task is overdue or not." }, as: :overdue
      expose :created_at, documentation: { type: Time,    desc: "The task creation date." }
    end
  end
end
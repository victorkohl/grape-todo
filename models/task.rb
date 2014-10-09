class Task
  include Mongoid::Document

  field :description, type: String
  field :done,        type: Boolean, default: false

  validates_presence_of :description, :done


  # Entity
  class Entity < Grape::Entity
    format_with(:simple_id) { |id| id.to_s }

    with_options(format_with: :simple_id) do
      expose :id,         documentation: { type: String,  desc: "The task ID." }
    end
    expose :description,  documentation: { type: String,  desc: "The description of task." }
    expose :done,         documentation: { type: Boolean, desc: "Whether the task is completed or not." }
  end
end
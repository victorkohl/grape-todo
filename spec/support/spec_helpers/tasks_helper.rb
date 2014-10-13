module TasksHelper
  def task_entity(task_object, version = 'v1')
    Task::Entity.new(task_object, version: version).serializable_hash.stringify_keys
  end
end
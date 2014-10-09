module Todo
  class V1 < Grape::API
    module Resources
      class Tasks < Grape::API

        resource :tasks do
          # GET /
          desc "Return the list of tasks."
          get do
            present Task.all
          end

          # POST /
          desc "Creates a task."
          params do
            requires :all, except: [:done], using: Task::Entity.documentation.except(:id)
          end
          post do
            status 201
            present Task.create!(permit_params(:description, :done))
          end

          # GET /:id
          desc "View a task by its id."
          params do
            requires :id, type: String, desc: "The task ID."
          end
          get ":id" do
            present Task.find(params.id)
          end

          # PATCH /:id
          desc "Edit a task."
          params do
            requires :id
          end
          patch ":id" do
            task = Task.find(params.id)
            task.update(permit_params(:description, :done))
            present task
          end

          # DELETE /:id
          desc "Delete a task."
          params do
            requires :id
          end
          delete ":id" do
            task = Task.find(params.id)
            task.destroy
            present task
          end
        end

      end
    end
  end
end
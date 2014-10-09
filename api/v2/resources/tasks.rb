module Todo
  class V2 < Grape::API
    module Resources
      class Tasks < Grape::API

        resource :tasks do
          # POST /
          desc "Creates a task."
          params do
            requires :description
            requires :due_date
          end
          post do
            status 201
            present Task.create!(permit_params(:description, :done, :due_date))
          end
        end

      end
    end
  end
end
require 'spec_helper'

describe Todo::V2 do
  include Rack::Test::Methods
  include TasksHelper

  def app
    Todo::API.new
  end

  before(:each) do
    Task.destroy_all
  end

  describe Todo::V2::Resources::Tasks do

    describe "GET /v2/tasks" do
      it "should return an empty list of Tasks" do
        get "/v2/tasks"
        expect(last_response.status).to eq(200)
        expect(JSON.parse(last_response.body)).to eq []
      end

      it "should return a list of Tasks" do
        task = Task.create!(description: "Test", done: true)
        get "/v2/tasks"
        expect(last_response.status).to eq(200)
        expect(JSON.parse(last_response.body)).to eq [task_entity(task, 'v2')]
      end
    end

    describe "GET /v2/tasks/:id" do
      it "should return an empty Task resource" do
        get "/v2/tasks/1"
        expect(last_response.status).to eq(404)
        expect(JSON.parse(last_response.body)).to eq({})
      end

      it "should return a valid Task resource" do
        task = Task.create!(description: "Test", done: true)
        get "/v2/tasks/#{task.id}"
        expect(last_response.status).to eq(200)
        expect(JSON.parse(last_response.body)).to eq task_entity(task, 'v2')
      end
    end


    describe "POST /v2/tasks" do
      it "should create a new Task resource" do
        task = { description: "test", due_date: Time.now + 1.day }
        post "/v2/tasks", task.to_json, "CONTENT_TYPE" => "application/json"
        expect(last_response.status).to eq(201)
        response_json = JSON.parse(last_response.body)
        expect(response_json).to have_key("description")
        expect(response_json["description"]).to eq "test"
      end

      it "should require a description" do
        task = { done: true }
        post "/v2/tasks", task.to_json, "CONTENT_TYPE" => "application/json"
        expect(last_response.status).to eq(400)
        response_json = JSON.parse(last_response.body)
        expect(response_json).to have_key("error")
        expect(response_json["error"]).to include "description"
      end

      it "should require a due_date" do
        task = { done: true }
        post "/v2/tasks", task.to_json, "CONTENT_TYPE" => "application/json"
        expect(last_response.status).to eq(400)
        response_json = JSON.parse(last_response.body)
        expect(response_json).to have_key("error")
        expect(response_json["error"]).to include "due_date"
      end
    end


    describe "PATCH /v2/tasks/:id" do
      it "should edit an existing Task resource" do
        task = Task.create!(description: "Test", done: true)
        changed_task = { description: "changed test" }
        patch "/v2/tasks/#{task.id}", changed_task.to_json, "CONTENT_TYPE" => "application/json"
        expect(last_response.status).to eq(200)
        response_json = JSON.parse(last_response.body)
        expect(response_json).to have_key("description")
        expect(response_json["description"]).to eq "changed test"
      end

      it "should fail at editing an inexistant Task" do
        changed_task = { description: "changed test" }
        patch "/v2/tasks/1", changed_task.to_json, "CONTENT_TYPE" => "application/json"
        expect(last_response.status).to eq(404)
        expect(JSON.parse(last_response.body)).to eq({})
      end
    end


    describe "DELETE /v2/tasks/:id" do
      it "should delete an existing Task resource" do
        task = Task.create!(description: "Test", done: true)
        delete "/v2/tasks/#{task.id}"
        expect(last_response.status).to eq(200)
        expect(JSON.parse(last_response.body)).to eq task_entity(task, 'v2')
      end

      it "should fail at deleting an inexistant Task" do
        delete "/v2/tasks/1"
        expect(last_response.status).to eq(404)
        expect(JSON.parse(last_response.body)).to eq({})
      end
    end
    
  end

end
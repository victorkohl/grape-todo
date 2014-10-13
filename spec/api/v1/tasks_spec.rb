require 'spec_helper'

describe Todo::V1 do
  include Rack::Test::Methods
  include TasksHelper

  def app
    Todo::API.new
  end

  before(:each) do
    Task.destroy_all
  end

  describe Todo::V1::Resources::Tasks do
    describe "GET /v1/tasks" do
      it "should return an empty list of Tasks" do
        get "/v1/tasks"
        expect(last_response.status).to eq(200)
        expect(JSON.parse(last_response.body)).to eq []
      end

      it "should return a list of Tasks" do
        task = Task.create!(description: "Test", done: true)
        get "/v1/tasks"
        expect(last_response.status).to eq(200)
        expect(JSON.parse(last_response.body)).to eq [task_entity(task)]
      end
    end

    describe "GET /v1/tasks/:id" do
      it "should return an empty Task resource" do
        get "/v1/tasks/1"
        expect(last_response.status).to eq(404)
        expect(JSON.parse(last_response.body)).to eq({})
      end

      it "should return a valid Task resource" do
        task = Task.create!(description: "Test", done: true)
        get "/v1/tasks/#{task.id}"
        expect(last_response.status).to eq(200)
        expect(JSON.parse(last_response.body)).to eq task_entity(task)
      end
    end


    describe "POST /v1/tasks" do
      it "should create a new Task resource" do
        task = { description: "test" }
        post "/v1/tasks", task.to_json, "CONTENT_TYPE" => "application/json"
        expect(last_response.status).to eq(201)
        response_json = JSON.parse(last_response.body)
        expect(response_json).to have_key("description")
        expect(response_json["description"]).to eq "test"
      end

      it "should require a description" do
        task = { done: true }
        post "/v1/tasks", task.to_json, "CONTENT_TYPE" => "application/json"
        expect(last_response.status).to eq(400)
        response_json = JSON.parse(last_response.body)
        expect(response_json).to have_key("error")
        expect(response_json["error"]).to include "description"
      end
    end


    describe "PATCH /v1/tasks/:id" do
      it "should edit an existing Task resource" do
        task = Task.create!(description: "Test", done: true)
        changed_task = { description: "changed test" }
        patch "/v1/tasks/#{task.id}", changed_task.to_json, "CONTENT_TYPE" => "application/json"
        expect(last_response.status).to eq(200)
        response_json = JSON.parse(last_response.body)
        expect(response_json).to have_key("description")
        expect(response_json["description"]).to eq "changed test"
      end

      it "should fail at editing an inexistant Task" do
        changed_task = { description: "changed test" }
        patch "/v1/tasks/1", changed_task.to_json, "CONTENT_TYPE" => "application/json"
        expect(last_response.status).to eq(404)
        expect(JSON.parse(last_response.body)).to eq({})
      end
    end


    describe "DELETE /v1/tasks/:id" do
      it "should delete an existing Task resource" do
        task = Task.create!(description: "Test", done: true)
        delete "/v1/tasks/#{task.id}"
        expect(last_response.status).to eq(200)
        expect(JSON.parse(last_response.body)).to eq task_entity(task)
      end

      it "should fail at deleting an inexistant Task" do
        delete "/v1/tasks/1"
        expect(last_response.status).to eq(404)
        expect(JSON.parse(last_response.body)).to eq({})
      end
    end
  end

end
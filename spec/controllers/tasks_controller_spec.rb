require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  before(:each) do
    @user = User.create(name: "The Doctor", email: "doctor@thetardis.com", password: "Fantastic!",password_confirmation: "Fantastic!")
    @board= Board.create(name: "Web Dev", user_id: @user.id)
    @list = List.create(board_id: @board.id, position_id: 1, name: "Interested In")
    @card = Card.create(organization_name: "Google", list_id: @list.id)
    @tasks = @card.tasks
    @original_task = Task.create(title: "Sample task", card_id: @card.id)
  end

  describe "GET #index" do
    it "loads all of a card's tasks" do
      get :index, card_id: @card.id
      expect(assigns(:tasks)).to match_array(@tasks)
    end
  end

  describe "POST #create" do
    before(:each) do
      post :create, card_id: @card, task: { title: "Some task", card_id: @card.id }
    end
    context "when is successfully created" do
      it "responds with a success 200 code" do
        expect(response).to have_http_status 200
      end

      it "increments the task count by 1" do
        expect{
          post :create, card_id: @card, task: { title: "New task", card_id: @card.id }
        }.to change{Task.count}.by(1)
      end

      it "renders a JSON of the created task" do
        body = response.body
        ## This seems hacky and unsafe to rely on
        json_task = Task.last.to_json
        expect(body).to eql(json_task)
      end

      it "renders the task json title" do
        task_json = JSON.parse(response.body, symbolize_names: true)
        expect(task_json[:title]).to eql "Some task"
      end
    end

    context "when is not created" do
      before(:each) do
        @invalid_attributes = { title: "No" }
        post :create, card_id: @card, task: @invalid_attributes
      end

      it { is_expected.to respond_with 422 }

      it "renders an errors json" do
        task_json = JSON.parse(response.body, symbolize_names: true)
        expect(task_json).to have_key(:errors)
      end

      it "renders the json errors on why the board could not be created" do
        task_json = JSON.parse(response.body, symbolize_names: true)
        expect(task_json[:errors][:title]).to include "can't be blank"
      end
    end
  end

  describe "PUT #update" do
    before(:each) do
      @valid_attributes = { title: "Another task", card_id: @card.id }
      put :update, card_id: @card, id: @original_task, task: @valid_attributes
    end
    context "when is successfully updated" do
      it "responds with a success 200 code" do
        expect(response).to have_http_status 200
      end

      it "updates the edited field" do
        task_response = JSON.parse(response.body, symbolize_names: true)
        expect(task_response[:title]).to eql(@valid_attributes[:title])
      end

      it "does not change the task count" do
        expect{
          put :update, card_id: @card, id: @original_task, task: @valid_attributes
          }.to change{Task.count}.by(0)
      end

      it "renders a JSON of the updated task" do
        body = response.body
        json_task = @task.to_json
        expect(body).to match(json_task)
      end
    end

    context "when is not updated" do
      before(:each) do
        @invalid_attributes = { title: "No" }
        put :update, card_id: @card, id: @original_task, task: @invalid_attributes
      end

      it { is_expected.to respond_with 422 }

      it "renders an errors json" do
        task_json = JSON.parse(response.body, symbolize_names: true)
        expect(task_json).to have_key(:errors)
      end

      it "renders the json errors on why the board could not be created" do
        task_json = JSON.parse(response.body, symbolize_names: true)
        expect(task_json[:errors][:title]).to include "can't be blank"
      end
    end
  end

  describe "DELETE #destroy" do
    context "when is successfully destroyed" do
      before(:each) do
        @task = Task.create(title: "Cool task", card_id: @card.id)
      end

      it "changes the task count by -1" do
        expect{
          delete :destroy, card_id: @card.id, id: @task.id
        }.to change{Task.count}.by(-1)
      end

      it "has a success 200 status code" do
        delete :destroy, card_id: @card, id: @task
        expect(response).to have_http_status(200)
      end

      it "renders a json success" do
        delete :destroy, card_id: @card, id: @task
        success_response = JSON.parse(response.body, symbolize_names: true)
        expect(success_response).to have_key(:success)
      end
    end

    context "when it fails to find a task to destroy" do
      it "renders an errors json" do
        delete :destroy, card_id: @card, id: "fail"
        success_response = JSON.parse(response.body, symbolize_names: true)
        expect(success_response).to have_key(:errors)
      end

      it "renders the json errors on why the task could not be destroyed" do
        delete :destroy, card_id: @card, id: "foo"
        destroy_response = JSON.parse(response.body, symbolize_names: true)
        expect(destroy_response[:errors][:id]).to include "not found"
      end
    end
  end
end

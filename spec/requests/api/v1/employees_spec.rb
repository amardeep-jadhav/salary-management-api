require 'rails_helper'

RSpec.describe "Api::V1::Employees", type: :request do
  let!(:department) { create(:department) }
  let!(:job_title)  { create(:job_title) }
  let!(:employee)   { create(:employee, department: department, job_title: job_title) }

  let(:valid_params) do
    {
      employee: {
        full_name:       Faker::Name.name,
        email:           Faker::Internet.unique.email,
        phone:           Faker::PhoneNumber.phone_number,
        gender:          'Male',
        country:         'US',
        city:            'New York',
        department_id:   department.id,
        job_title_id:    job_title.id,
        employment_type: 'full_time',
        salary:          75_000.00,
        currency:        'USD',
        hired_on:        '2022-01-01',
        date_of_birth:   '1990-05-15',
        active:          true
      }
    }
  end

  let(:invalid_params) do
    {
      employee: {
        full_name: '',
        email:     'not-an-email',
        salary:    -100
      }
    }
  end

  describe "GET /api/v1/employees" do
    it "returns http success" do
      get "/api/v1/employees"
      expect(response).to have_http_status(:ok)
    end

    it "returns paginated employees" do
      get "/api/v1/employees"
      json = JSON.parse(response.body)
      expect(json["data"]).to be_an(Array)
      expect(json["meta"]).to be_present
    end

    it "filters by country" do
      get "/api/v1/employees", params: { country: employee.country }
      json = JSON.parse(response.body)
      expect(json["data"].length).to be >= 1
    end

    it "searches by name" do
      get "/api/v1/employees", params: { search: employee.full_name }
      json = JSON.parse(response.body)
      expect(json["data"].length).to be >= 1
    end
  end

  describe "GET /api/v1/employees/:id" do
    it "returns the employee" do
      get "/api/v1/employees/#{employee.id}"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["id"]).to eq(employee.id)
    end

    it "returns 404 for unknown employee" do
      get "/api/v1/employees/#{SecureRandom.uuid}"
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /api/v1/employees" do
    context "with valid params" do
      it "creates an employee" do
        expect {
          post "/api/v1/employees", params: valid_params
        }.to change(Employee, :count).by(1)
        expect(response).to have_http_status(:created)
      end

      it "returns the created employee" do
        post "/api/v1/employees", params: valid_params
        json = JSON.parse(response.body)
        expect(json["full_name"]).to eq(valid_params[:employee][:full_name])
      end
    end

    context "with invalid params" do
      it "returns unprocessable entity" do
        post "/api/v1/employees", params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns error messages" do
        post "/api/v1/employees", params: invalid_params
        json = JSON.parse(response.body)
        expect(json["errors"]).to be_present
      end
    end
  end

  describe "PATCH /api/v1/employees/:id" do
    context "with valid params" do
      it "updates the employee" do
        patch "/api/v1/employees/#{employee.id}",
              params: { employee: { full_name: "Updated Name" } }
        expect(response).to have_http_status(:ok)
        expect(employee.reload.full_name).to eq("Updated Name")
      end
    end

    context "with invalid params" do
      it "returns unprocessable entity" do
        patch "/api/v1/employees/#{employee.id}",
              params: { employee: { salary: -999 } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /api/v1/employees/:id" do
    it "soft deletes the employee" do
      delete "/api/v1/employees/#{employee.id}"
      expect(response).to have_http_status(:ok)
      expect(employee.reload.active).to eq(false)
    end

    it "returns 404 for unknown employee" do
      delete "/api/v1/employees/#{SecureRandom.uuid}"
      expect(response).to have_http_status(:not_found)
    end
  end
end

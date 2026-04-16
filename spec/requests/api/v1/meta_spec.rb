require 'rails_helper'

RSpec.describe "Api::V1::Meta", type: :request do
  let!(:department) { create(:department) }
  let!(:job_title)  { create(:job_title) }
  let!(:employee)   { create(:employee, department: department, job_title: job_title) }

  describe "GET /api/v1/meta/countries" do
    it "returns http success" do
      get "/api/v1/meta/countries"
      expect(response).to have_http_status(:ok)
    end

    it "returns list of distinct countries" do
      get "/api/v1/meta/countries"
      json = JSON.parse(response.body)
      expect(json["countries"]).to be_an(Array)
      expect(json["countries"]).to include(employee.country)
    end
  end

  describe "GET /api/v1/meta/departments" do
    it "returns http success" do
      get "/api/v1/meta/departments"
      expect(response).to have_http_status(:ok)
    end

    it "returns list of departments" do
      get "/api/v1/meta/departments"
      json = JSON.parse(response.body)
      expect(json["departments"]).to be_an(Array)
      expect(json["departments"].first["id"]).to be_present
      expect(json["departments"].first["name"]).to be_present
    end
  end

  describe "GET /api/v1/meta/job_titles" do
    it "returns http success" do
      get "/api/v1/meta/job_titles"
      expect(response).to have_http_status(:ok)
    end

    it "returns list of job titles" do
      get "/api/v1/meta/job_titles"
      json = JSON.parse(response.body)
      expect(json["job_titles"]).to be_an(Array)
      expect(json["job_titles"].first["id"]).to be_present
      expect(json["job_titles"].first["name"]).to be_present
      expect(json["job_titles"].first["level"]).to be_present
    end
  end
end

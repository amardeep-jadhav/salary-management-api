require 'rails_helper'

RSpec.describe "Api::V1::Insights", type: :request do
  let!(:department) { create(:department) }
  let!(:job_title)  { create(:job_title, level: 'Senior') }

  before do
    create_list(:employee, 3,
      department: department,
      job_title: job_title,
      country: 'US',
      salary: 80_000,
      currency: 'USD',
      active: true,
      hired_on: 30.days.ago
    )
    create_list(:employee, 2,
      department: department,
      job_title: job_title,
      country: 'IN',
      salary: 40_000,
      currency: 'USD',
      active: true,
      hired_on: 60.days.ago
    )
  end

  describe "GET /api/v1/insights/salary" do
    it "returns http success" do
      get "/api/v1/insights/salary"
      expect(response).to have_http_status(:ok)
    end

    it "returns salary stats by country" do
      get "/api/v1/insights/salary"
      json = JSON.parse(response.body)
      expect(json["salary_by_country"]).to be_present
    end

    it "returns correct min max avg for country" do
      get "/api/v1/insights/salary", params: { country: "US" }
      json = JSON.parse(response.body)
      stats = json["salary_by_country"].first
      expect(stats["min_salary"].to_f).to eq(80_000.0)
      expect(stats["max_salary"].to_f).to eq(80_000.0)
      expect(stats["avg_salary"].to_f).to eq(80_000.0)
      expect(stats["headcount"]).to eq(3)
    end

    it "returns avg salary by job title in country" do
      get "/api/v1/insights/salary", params: { country: "US" }
      json = JSON.parse(response.body)
      expect(json["salary_by_job_title"]).to be_present
    end

    it "returns headcount by department" do
      get "/api/v1/insights/salary"
      json = JSON.parse(response.body)
      expect(json["headcount_by_department"]).to be_present
    end

    it "returns salary distribution" do
      get "/api/v1/insights/salary"
      json = JSON.parse(response.body)
      expect(json["salary_distribution"]).to be_present
    end

    it "returns top paid roles" do
      get "/api/v1/insights/salary"
      json = JSON.parse(response.body)
      expect(json["top_paid_roles"]).to be_present
    end

    it "returns recent hires" do
      get "/api/v1/insights/salary"
      json = JSON.parse(response.body)
      expect(json["recent_hires"]).to be_present
    end
  end
end

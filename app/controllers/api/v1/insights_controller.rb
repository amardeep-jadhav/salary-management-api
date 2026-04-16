module Api
  module V1
    class InsightsController < ApplicationController
      def salary
        query = SalaryInsightsQuery.new(insights_params)

        render json: {
          salary_by_country:      query.salary_by_country,
          salary_by_job_title:    query.salary_by_job_title,
          headcount_by_department: query.headcount_by_department,
          salary_distribution:    query.salary_distribution,
          top_paid_roles:         query.top_paid_roles,
          recent_hires:           query.recent_hires
        }, status: :ok
      end

      private

      def insights_params
        params.permit(:country)
      end
    end
  end
end

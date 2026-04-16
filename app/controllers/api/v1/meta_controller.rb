module Api
  module V1
    class MetaController < ApplicationController
      def countries
        render json: { countries: MetaQuery.new.countries }, status: :ok
      end

      def departments
        render json: { departments: MetaQuery.new.departments }, status: :ok
      end

      def job_titles
        render json: { job_titles: MetaQuery.new.job_titles }, status: :ok
      end
    end
  end
end

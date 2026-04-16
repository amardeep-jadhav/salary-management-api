module Api
  module V1
    class MetaController < ApplicationController
      def countries
        countries = Employee.active
                            .distinct
                            .pluck(:country)
                            .sort
        render json: { countries: countries }, status: :ok
      end

      def departments
        departments = Department.order(:name)
                                .pluck(:id, :name)
                                .map { |id, name| { id: id, name: name } }
        render json: { departments: departments }, status: :ok
      end

      def job_titles
        job_titles = JobTitle.order(:name)
                             .pluck(:id, :name, :level)
                             .map { |id, name, level| { id: id, name: name, level: level } }
        render json: { job_titles: job_titles }, status: :ok
      end
    end
  end
end

module Api
  module V1
    class EmployeesController < ApplicationController
      before_action :set_employee, only: %i[show update destroy]

      def index
        employees = EmployeeQuery.new(filter_params).call
        pagy, paginated = pagy(employees)
        render json: {
          data: EmployeeBlueprint.render_as_hash(paginated, view: :normal),
          meta: {
            current_page:  pagy.page,
            total_pages:   pagy.pages,
            total_count:   pagy.count,
            per_page:      pagy.items,
            next_page:     pagy.next,
            prev_page:     pagy.prev
          }
        }, status: :ok
      end

      def show
        render json: EmployeeBlueprint.render_as_hash(@employee, view: :normal), status: :ok
      end

      def create
        result = Employees::Creator.new(employee_params).call
        if result.success?
          render json: EmployeeBlueprint.render_as_hash(result.payload, view: :normal), status: :created
        else
          render json: { errors: result.errors }, status: :unprocessable_content
        end
      end

      def update
        result = Employees::Updater.new(@employee, employee_params).call
        if result.success?
          render json: EmployeeBlueprint.render_as_hash(result.payload, view: :normal), status: :ok
        else
          render json: { errors: result.errors }, status: :unprocessable_content
        end
      end

      def destroy
        result = Employees::Destroyer.new(@employee).call
        if result.success?
          render json: { message: "Employee deactivated successfully" }, status: :ok
        else
          render json: { errors: result.errors }, status: :unprocessable_content
        end
      end

      private

      def set_employee
        @employee = Employee.find(params[:id])
      end

      def employee_params
        params.require(:employee).permit(
          :full_name, :email, :phone, :gender,
          :country, :city, :department_id, :job_title_id,
          :employment_type, :salary, :currency,
          :hired_on, :date_of_birth, :active
        )
      end

      def filter_params
        params.permit(:country, :department_id, :search, :sort, :direction)
      end
    end
  end
end

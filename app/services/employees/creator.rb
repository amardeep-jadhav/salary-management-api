module Employees
  class Creator
    def initialize(params)
      @params = params
    end

    def call
      employee = Employee.new(@params)
      if employee.save
        ServiceResult.success(payload: employee)
      else
        ServiceResult.failure(errors: employee.errors.full_messages)
      end
    end
  end
end

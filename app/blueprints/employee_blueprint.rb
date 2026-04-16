class EmployeeBlueprint < Blueprinter::Base
  identifier :id

  view :normal do
    fields :full_name, :email, :phone, :gender,
           :country, :city, :employment_type,
           :salary, :currency, :hired_on,
           :date_of_birth, :active,
           :created_at, :updated_at

    association :department, blueprint: DepartmentBlueprint
    association :job_title, blueprint: JobTitleBlueprint
  end

  view :summary do
    fields :full_name, :email, :country,
           :salary, :currency, :employment_type, :active
    association :department, blueprint: DepartmentBlueprint
    association :job_title, blueprint: JobTitleBlueprint
  end
end

class MetaQuery
  def countries
    Employee.active
            .distinct
            .pluck(:country)
            .sort
  end

  def departments
    Department.order(:name)
              .pluck(:id, :name)
              .map { |id, name| { id: id, name: name } }
  end

  def job_titles
    JobTitle.order(:name)
            .pluck(:id, :name, :level)
            .map { |id, name, level| { id: id, name: name, level: level } }
  end
end

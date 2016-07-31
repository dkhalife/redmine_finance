class OperationImportsController < ImporterBaseController
  menu_item :finance

  def klass
    OperationImport
  end

  def instance_index
    project_operations_path(:project_id => @project)
  end
end

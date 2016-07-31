class AccountCustomField < CustomField
  unloadable
  
  def type_name
    :label_account_plural
  end
end
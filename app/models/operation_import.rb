# <PRO>
class OperationImport
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations
  include CSVImportable

  attr_accessor :file, :project, :quotes_type

  def klass
    Operation
  end

  def build_from_fcsv_row(row)
    ret = Hash[row.to_hash.map{ |k,v| [k.underscore.gsub(' ','_'), force_utf8(v)] }].delete_if{ |k,v| !klass.column_names.include?(k) }
    ret[:category_id] =  OperationCategory.named(row['operation type']).first.try(:id)
    ret[:account_id] =  project.accounts.named(row['account']).first.try(:id)
    if row['contact'].to_s.match(/^\#(\d+):/)
      ret[:contact_id] = Contact.find_by_id($1).try(:id)
    end
    ret[:operation_date] = Date.parse(row['operation date']) rescue Date.strptime(row['operation date'], '%m/%d/%Y')
    ret[:author] = User.current
    ret[:amount] = row['income'].to_i > 0 ? row['income'] : row['expense']
    ret[:id] = nil
    ret
  end

end
# </PRO>
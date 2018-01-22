class AddTotalDisbursementToScholar < ActiveRecord::Migration[5.1]
  def change
    add_column :scholars, :total_disbursement_allotment, :decimal, :precision => 11, :scale => 2
  end
end

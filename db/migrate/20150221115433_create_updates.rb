class CreateUpdates < ActiveRecord::Migration
  def change
    create_table :updates do |t|
    	t.text :title
    	t.text :body
    	t.date :date
    	t.integer :course_id
      t.boolean :isHW
      t.boolean :isExam
      t.boolean :isPiazza
      t.timestamps
    end
  end
end

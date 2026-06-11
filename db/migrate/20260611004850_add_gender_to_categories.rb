class AddGenderToCategories < ActiveRecord::Migration[7.1]
  def up
    unless column_exists?(:categories, :gender_id)
      add_reference :categories, :gender, foreign_key: true, null: true
    end

    execute <<~SQL
      INSERT INTO genders (name, slug, position, active, created_at, updated_at)
      SELECT 'Feminino', 'feminino', 1, TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
      WHERE NOT EXISTS (
        SELECT 1 FROM genders WHERE slug = 'feminino'
      );
    SQL

    default_gender_id = select_value("SELECT id FROM genders WHERE slug = 'feminino' LIMIT 1")

    execute <<~SQL
      UPDATE categories
      SET gender_id = #{default_gender_id}
      WHERE gender_id IS NULL;
    SQL

    change_column_null :categories, :gender_id, false
  end

  def down
    if column_exists?(:categories, :gender_id)
      remove_reference :categories, :gender, foreign_key: true
    end
  end
end

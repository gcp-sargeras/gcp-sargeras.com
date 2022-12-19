class UpdateSimcReport < ActiveRecord::Migration[7.0]
  def up
    add_reference :simc_reports, :wow_character, foreign_key: true

    Simc::Report.find_each do |simc_report|
      region = Wow::Region.find_or_create_by!(name: simc_report.region)
      server = Wow::Server.find_or_create_by!(name: simc_report.server)
      character = Wow::Character.find_or_create_by!(name: simc_report.character, server: server, region: region)

      simc_report.update(
        wow_character_id: character.id,
      )
    end

    remove_column :simc_reports, :region
    remove_column :simc_reports, :server
    remove_column :simc_reports, :character

    change_column_null :simc_reports, :wow_character_id, null: false
  end

  def down
    add_column :simc_reports, :region, :string
    add_column :simc_reports, :server, :string
    add_column :simc_reports, :character, :string

    Simc::Report.find_each do |simc_report|
      character = Wow::Character.find(simc_report.wow_character_id)

      simc_report.update(
        region: character.region.name,
        server: character.server.name,
        character: character.name
      )
    end

    remove_reference :simc_reports, :wow_character

    change_column_null :simc_reports, :region, null: false
    change_column_null :simc_reports, :server, null: false
    change_column_null :simc_reports, :character, null: false
  end
end
